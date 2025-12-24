# 🏗️ Teknik Mimari - Oyun Motoru Yaklaşımları

## Paradox/Firaxis Oyunlarının Kullandığı Temel Metotlar

---

### 1. Data-Driven Architecture (Veri Odaklı Mimari)

**Oyunlarda:** Tüm sayısal değerler ve kurallar kod içinde değil, harici dosyalarda (XML, JSON, Lua) tanımlı. EU4'te `defines.lua`, Civ6'da XML/SQL dosyaları.

**Bizim için:** 
- Tüm parametreler (eylem maliyetleri, başarı oranları, decay değerleri) veritabanında veya JSON konfigürasyonda saklanacak
- Kod sadece mantığı işler, sayıları konfigürasyondan okur
- Simülasyon başlamadan önce değerler kolayca ayarlanabilir
- Oyun sırasında bile admin panelinden değiştirilebilir

---

### 2. Modifier Stack Sistemi

**Oyunlarda:** Hiçbir değer sabit değil. Her değer = Baz Değer + Tüm Aktif Modifierlar. Modifierlar farklı kaynaklardan gelir ve zamanla eklenip çıkarılır.

**İki tip modifier:**
- **Flat (Düz):** Değere doğrudan eklenir (+5, -10 gibi)
- **Percent (Yüzde):** Değeri yüzdesel değiştirir (+15%, -20% gibi)

**Hesaplama formülü:**
```
Final = (Baz + Tüm Flat Bonuslar) × (1 + Toplam Yüzde / 100)
```

**Bizim için:**
- Her ülkenin her kaynağı için modifier listesi tutulacak
- Anlaşmalar, olaylar, eylemler modifier olarak eklenir
- Her modifierin kaynağı, süresi ve değeri kayıtlı
- Tur sonunda süresi dolanlar otomatik kaldırılır

---

### 3. Turn-Based Processing (Tur Bazlı İşleme)

**Oyunlarda:** Her zaman birimi (tick/tur) sonunda tüm sistem toplu olarak güncellenir. Sıralı ve öngörülebilir.

**Tur sonu işlem sırası:**
1. Kaynak üretimlerini hesapla
2. Decay değerlerini uygula (şikayet azalması, gerilim düşüşü)
3. Süresi dolan modifierleri kaldır
4. Zamanlanmış olayları tetikle
5. Rastgele olayları kontrol et
6. State'i kaydet
7. Kullanıcılara bildir

**Bizim için:**
- 30 dakikalık turlar, her tur sonunda backend toplu hesaplama yapar
- Tüm ülkeler aynı anda güncellenir (sıra avantajı yok)
- İşlem sırası sabit ve şeffaf

---

### 4. Relation Matrix (İlişki Matrisi)

**Oyunlarda:** Her ülke çifti için ayrı ilişki değerleri. Tek yönlü değil, çift yönlü ve bağımsız. A'nın B'ye bakışı ≠ B'nin A'ya bakışı.

**Bizim için:**
- 8 ülke = 8×8 = 64 ilişki kaydı
- Her kayıtta: güven puanı, şikayet puanı, iyilik borcu
- Eylemler sadece ilgili ilişkileri günceller

---

### 5. Event System (Olay Sistemi)

**Oyunlarda:** Olaylar koşullara bağlı tetiklenir. Her olay: tetikleme koşulu, etkileri, oyuncu seçenekleri içerir.

**Olay türleri:**
- **Scheduled (Zamanlanmış):** Belirli turda tetiklenir
- **Conditional (Koşullu):** Belirli durum oluşunca tetiklenir
- **Random (Rastgele):** Olasılık bazlı, her tur kontrol edilir
- **Chain (Zincir):** Bir olay diğerini tetikler

**Bizim için:**
- Admin panelinden olay zamanlanabilir
- Ülke durumuna göre rastgele olaylar (düşük prestij = darbe riski)
- Oyuncu eylemleri zincir olay başlatabilir

---

### 6. Caching ve Lazy Calculation

**Oyunlarda:** Her şey her an hesaplanmaz. Değerler cache'lenir, sadece ilgili modifier değişince yeniden hesaplanır.

**Bizim için:**
- Hesaplanan final değerler cache'te tutulur
- Modifier eklenince/çıkınca sadece o değerin cache'i temizlenir
- Kullanıcı isteyince cache'ten hızlıca okunur

---

### 7. Delta Updates (Fark Güncellemesi)

**Oyunlarda:** Network üzerinden tüm state değil, sadece değişen kısımlar gönderilir.

**Bizim için:**
- WebSocket ile sadece değişen değerler yayınlanır
- Her ülke sadece kendi görebildiği değişiklikleri alır
- Bandwidth ve performans optimizasyonu

---

### 8. Visibility Layers (Görünürlük Katmanları)

**Oyunlarda:** Her oyuncu sadece bilmesi gerekeni görür. Fog of war, gizli anlaşmalar, istihbarat seviyesine göre bilgi erişimi.

**Bizim için:**
- Ülkeler sadece kendi kaynaklarını tam görür
- Diğer ülkelerin kaynakları: istihbarat varsa tahmin, yoksa belirsiz
- Gizli anlaşmalar sadece taraflara görünür
- Gizli operasyonlar başarısız/ifşa olunca açığa çıkar

---

## Veritabanı Yaklaşımı

| Tablo | İçerik | Güncelleme Sıklığı |
|-------|--------|-------------------|
| `game_config` | Tüm parametreler (JSON) | Oyun başında |
| `game_state` | Genel durum (tur, gerilim) | Her tur |
| `countries` | Ülke kaynakları | Her tur |
| `modifiers` | Aktif modifierlar | Eylem bazlı |
| `relations` | İlişki matrisi | Eylem bazlı |
| `actions_log` | Eylem geçmişi | Her eylem |
| `events` | Zamanlanmış olaylar | Admin tarafından |

---

## Real-Time Yapısı

**WebSocket Odaları:**
- `game:global` → Herkesin gördüğü (dünya gerilimi, haberler)
- `game:country:{id}` → Ülke özel (kendi kaynakları, gelen mesajlar)
- `game:role:{role}` → Rol bazlı (medya kendi aralarında)
- `game:admin` → Organizatör paneli

**Yayın Mantığı:**
- Açık eylemler → Global
- Ülke içi değişiklikler → Sadece o ülkeye
- Gizli operasyonlar → Sadece aktöre (başarılı olsa bile)
- Tespit edilen gizli işler → Hedefe de bildirim

---

## Performans Kuralları

1. **Toplu Sorgular:** Tur sonu işlemlerinde tek sorguda tüm ülkeler güncellenir
2. **Cache Kullanımı:** Sık okunan değerler Redis'te
3. **Lazy Loading:** Detaylar sadece istendiğinde yüklenir
4. **Debounce:** Hızlı art arda gelen istekler birleştirilir

---

## Önerilen Teknoloji Stack

| Katman | Teknoloji | Neden |
|--------|-----------|-------|
| Frontend | Next.js + React | SSR, kolay routing |
| Real-time | Socket.io | WebSocket yönetimi |
| Backend | Node.js / Express | Tek dil, hızlı geliştirme |
| Database | PostgreSQL | İlişkisel veri, JSON desteği |
| Cache | Redis | Hızlı okuma, pub/sub |
| Hosting | Vercel + Railway | Kolay deployment |

**Alternatif (daha performanslı):** Go backend + native WebSocket

---

*Bu doküman, strateji oyunlarının kullandığı temel mimari yaklaşımları ve bunların web tabanlı diplomasi simülasyonuna nasıl uygulanacağını özetler.*
