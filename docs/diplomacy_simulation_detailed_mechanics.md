# 🎯 Diplomasi Simülasyonu - Detaylı Mekanik Tasarımı

**Format:** 2 Gün × 6 Saat = 12 Saat Toplam  
**Mod:** Real-time, sıkıştırılmış zaman

---

## ⏱️ Sıkıştırılmış Zaman Sistemi

### Konsept
Site içinde zaman hızlı akar (örn: 1 gerçek saat = 1 oyun ayı). Oyuncular fiziksel dünyada müzakere yapar, site üzerinden aksiyonları uygular.

### Zaman Akışı Örneği

| Gerçek Süre | Oyun Zamanı | Açıklama |
|-------------|-------------|----------|
| 0:00-0:30 | Ocak 2025 | Başlangıç, durum değerlendirme |
| 0:30-1:00 | Şubat 2025 | İlk aksiyonlar |
| 1:00-1:30 | Mart 2025 | Sonuçlar görülür |
| ... | ... | ... |
| 5:30-6:00 | Aralık 2025 | 1. Gün sonu |

### Fiziksel-Dijital Entegrasyon

```
DÖNGÜ (Her 30 dakikada bir):
┌─────────────────────────────────────────────────┐
│ 1. MÜZAKERE (15 dk) - Fiziksel                  │
│    • Ülkeler arası yüz yüze görüşme             │
│    • Gizli anlaşmalar                           │
│    • Tehditler/teklifler                        │
├─────────────────────────────────────────────────┤
│ 2. AKSİYON (10 dk) - Dijital                    │
│    • Site üzerinden eylemleri girme             │
│    • Kaynak harcama                             │
│    • Emirleri onaylama                          │
├─────────────────────────────────────────────────┤
│ 3. SONUÇ (5 dk) - Dijital                       │
│    • Sistem sonuçları hesaplar                  │
│    • Harita güncellenir                         │
│    • Haberler yayınlanır                        │
└─────────────────────────────────────────────────┘
```

---

## ⚔️ AKSİYON SİSTEMİ (Detaylı)

### Temel Prensipler
1. **Sınırlı Kaynak** - Her eylem kaynak tüketir
2. **Kesin Sonuç** - Her eylem geri dönüşsüz etki yaratır
3. **Karşılıklı Bağımlılık** - Bir ülkenin eylemi diğerlerini etkiler
4. **Görünürlük Katmanları** - Bazı eylemler gizli, bazıları açık

### Kaynak Havuzu (Her Ülke İçin)

| Kaynak | Başlangıç | Yenileme | Kullanım |
|--------|-----------|----------|----------|
| 💰 Bütçe | 100 | +10/tur | Her şey |
| ⚔️ Askeri Güç | 50 | +5/tur | Savaş, caydırıcılık |
| 🕵️ İstihbarat | 30 | +3/tur | Gizli operasyonlar |
| 🤝 Diplomasi | 40 | +4/tur | Anlaşmalar |
| 📊 Prestij | 50 | Değişken | Yumuşak güç |
| 🏭 Sanayi | 60 | +2/tur | Üretim, teknoloji |

### Aksiyon Kategorileri

#### 1. ASKERİ EYLEMLER

| Eylem | Maliyet | Süre | Etki | Risk |
|-------|---------|------|------|------|
| **Savaş İlanı** | 30💰 + 40⚔️ | Anlık | Toprak savaşı başlar | Prestij kaybı, düşman kazanma |
| **Askeri Yığınak** | 15💰 + 10⚔️ | 1 tur | Sınırda güç artışı | Gerilim tırmanması |
| **Barış Gücü Gönder** | 10💰 + 5⚔️ | 2 tur | Bölgede istikrar | Asker kaybı riski |
| **Silah Satışı** | -5💰 (gelir) | Anlık | Müttefik güçlenir | Bölgesel silah yarışı |
| **Deniz Ablukası** | 20💰 + 15⚔️ | Devam | Hedef ekonomisine zarar | Savaş riski |

**Savaş Mekaniği:**
```
Saldıran Güç = Askeri Kaynak + Sanayi Bonusu + Müttefik Desteği
Savunan Güç = Askeri Kaynak + Coğrafi Bonus + Moral

Sonuç = (Saldıran / Savunan) × Rastgele Faktör (0.8-1.2)
> 1.5 = Kesin zafer
1.0-1.5 = Kısmi zafer, yüksek kayıp
0.7-1.0 = Çıkmaz
< 0.7 = Yenilgi
```

#### 2. EKONOMİK EYLEMLER

| Eylem | Maliyet | Etki | Açıklama |
|-------|---------|------|----------|
| **Ticaret Anlaşması** | 5🤝 | +5💰/tur her iki tarafa | Karşılıklı bağımlılık |
| **Yaptırım Uygula** | 10🤝 + 5📊 | Hedefin geliri -%20 | Diplomatik bedel |
| **Altyapı Yatırımı** | 20💰 | +3🏭 kalıcı | Uzun vadeli güç |
| **Para Birimi Saldırısı** | 15💰 + 10🕵️ | Hedef ekonomisi kriz | Gizli, tespit riski |
| **Kalkınma Yardımı** | 10💰 | +10📊, hedefte etki | Yumuşak güç |

#### 3. DİPLOMATİK EYLEMLER

| Eylem | Maliyet | Etki |
|-------|---------|------|
| **İttifak Teklifi** | 15🤝 | Karşılıklı savunma paktı |
| **Saldırmazlık Paktı** | 5🤝 | 5 tur saldırı yasağı |
| **BM Kararı Öner** | 10🤝 + 5📊 | Çok taraflı eylem |
| **Büyükelçi Çağır** | 2🤝 | Diplomatik protesto |
| **Diplomatik İlişki Kes** | 0 | Tüm bonuslar sıfırlanır |
| **Arabuluculuk** | 8🤝 | İki taraf arasında barış |

#### 4. İSTİHBARAT EYLEMLER

| Eylem | Maliyet | Başarı | Sonuç |
|-------|---------|--------|-------|
| **Bilgi Toplama** | 5🕵️ | %80 | Hedefin kaynaklarını gör |
| **Sabotaj** | 15🕵️ | %50 | Hedefin sanayisine -10 |
| **Siber Saldırı** | 10🕵️ | %60 | Altyapı hasarı |
| **Dezenformasyon** | 8🕵️ | %70 | Hedefte iç karışıklık |
| **Ajan Yerleştir** | 20🕵️ | %40 | Uzun vadeli istihbarat |
| **Karşı İstihbarat** | 10🕵️ | Pasif | Düşman operasyonlarını engelle |

### Aksiyon Zincirleme Örneği

```
TUR 1: Ülke A, Ülke B'ye yaptırım uygular
       → Ülke B ekonomisi -%20
       
TUR 2: Ülke B, Ülke C ile ticaret anlaşması yapar (yaptırımı bypass)
       → Ülke A'nın yaptırımı etkisizleşir
       
TUR 3: Ülke A, Ülke C'ye baskı yapar (anlaşmayı boz)
       → Ülke C seçim yapmak zorunda: A mı B mi?
       
TUR 4: Ülke C reddeder, Ülke A askeri yığınak yapar
       → Tüm bölge gerilir, BM toplantısı çağrısı
```

---

## 👥 ROL DENGESİ SİSTEMİ

### Her Rolün Kritik Olmasını Sağlama

#### Prensip: "Tek Başına Hiçbir Şey Yapamaz"

Her büyük aksiyon **birden fazla rolün onayını** gerektirir:

| Aksiyon | Gereken Onaylar |
|---------|-----------------|
| Savaş İlanı | Başkan + Savunma + Dışişleri |
| Ticaret Anlaşması | Ekonomi + Dışişleri + Başkan |
| Siber Saldırı | İstihbarat + Siber Güvenlik |
| Basın Açıklaması | Sözcü + Başkan |
| Gizli Operasyon | İstihbarat + Savunma |

### Her Rol İçin Benzersiz Yetkiler

#### 👔 DEVLET BAŞKANI
```
Özel Yetkiler:
├── Veto hakkı (her türlü karara)
├── Acil durum ilan etme (ekstra kaynak)
├── Diğer liderlerle doğrudan hat
└── Nihai karar mercii

Kısıtlamalar:
├── Detaylı bilgiye erişemez (danışman gerekli)
├── Tek başına operasyon başlatamaz
└── Bütçeyi doğrudan kontrol edemez
```

#### 🌐 DIŞİŞLERİ BAKANI
```
Özel Yetkiler:
├── Anlaşma müzakere etme (tek yetkili)
├── Diplomatik kanalları açma/kapama
├── BM'de oy kullanma
└── Yabancı liderlerle iletişim

Kısıtlamalar:
├── Askeri emir veremez
├── Bütçe harcayamaz
└── Gizli operasyon başlatamaz
```

#### ⚔️ SAVUNMA BAKANI
```
Özel Yetkiler:
├── Askeri birlikleri konuşlandırma
├── Savaş planı hazırlama
├── Silah alım/satım kararı
└── Savunma bütçesini yönetme

Kısıtlamalar:
├── Savaş ilan edemez (başkan onayı)
├── Diplomatik temas kuramaz
└── Gizli operasyon yapamaz
```

#### 💰 EKONOMİ BAKANI
```
Özel Yetkiler:
├── Bütçe tahsisi (en kritik!)
├── Yaptırım uygulama/kaldırma
├── Ticaret anlaşması onayı
└── Ekonomik kriz yönetimi

Kısıtlamalar:
├── Dış politika belirleyemez
├── Askeri harcama için savunma onayı
└── Gizli bütçe için istihbarat onayı
```

#### 🕵️ İSTİHBARAT ŞEFİ
```
Özel Yetkiler:
├── Gizli operasyonlar (tek yetkili)
├── Düşman bilgilerini görme
├── Karşı istihbarat
└── Sızıntı tespiti

Kısıtlamalar:
├── Açık eylem yapamaz
├── Bütçe talep etmeli
└── Askeri operasyon için savunma onayı
```

#### 🛡️ SİBER GÜVENLİK EKİBİ
```
Özel Yetkiler:
├── Siber saldırı başlatma
├── Siber savunma
├── Veri koruma/sızıntı önleme
└── İletişim güvenliği

Kritik Rol:
└── Onay vermezse SİBER aksiyonlar çalışmaz!
```

#### 📢 SÖZCÜ / İLETİŞİM
```
Özel Yetkiler:
├── Medyayla iletişim (tek kanal)
├── Basın açıklaması
├── Kamuoyu algısını yönetme
└── Dezenformasyona karşı savunma

Kritik Rol:
└── Haber çıkmadan sözcü onayı şart!
```

### Rol Etkileşim Matrisi

```
                Başkan  Dışişleri  Savunma  Ekonomi  İstihbarat  Siber  Sözcü
Savaş           ✓ onay   ✓ onay    ✓ yürüt    -         -         -      -
Anlaşma         ✓ onay   ✓ yürüt     -      ✓ onay      -         -      -
Siber Ops        -         -         -        -       ✓ yürüt   ✓ onay   -
Yaptırım        ✓ onay     -         -      ✓ yürüt     -         -      -
Basın Açk.      ✓ onay     -         -        -         -         -    ✓ yürüt
Gizli Op.         -        -       ✓ onay     -       ✓ yürüt     -      -
```

---

## 🎲 DİNAMİK OLAY SİSTEMİ (Genişletilmiş)

### Olay Türleri

#### 1. ZAMANLI OLAYLAR (Kontrollü)
Organizatörün belirli zamanlarda tetiklediği olaylar.

```json
{
  "id": "ENERGY_CRISIS_Q2",
  "trigger": "Tur 8",
  "type": "ekonomik",
  "title": "Küresel Enerji Krizi",
  "description": "Orta Doğu'da beklenmedik üretim kesintisi",
  "global_effects": {
    "petrol_fiyati": "+50%",
    "tüm_ülkeler_ekonomi": "-5"
  },
  "special_effects": {
    "Suudi Arabistan": {"ekonomi": "+20", "prestij": "+10"},
    "Rusya": {"ekonomi": "+15"},
    "AB": {"ekonomi": "-15"}
  },
  "duration": "3 tur",
  "player_options": {
    "enerji_üreticileri": ["Fiyat artır", "Üretim artır", "Stabil tut"],
    "enerji_tüketicileri": ["Alternatif ara", "Stok kullan", "Anlaşma yap"]
  }
}
```

#### 2. RASTGELE OLAYLAR (Stat Bazlı Dinamik Olasılık)

Rastgele olaylar **ülkelerin iç dinamiklerinden** kaynaklanır. Olasılıklar sabit değil, **ülkenin mevcut statlarına göre** her tur yeniden hesaplanır.

**TEMEL MANTIK:**
```
Final Olasılık = Baz Olasılık + (Stat Modifierleri Toplamı)
```

---

**OLAY 1: DARBE GİRİŞİMİ**

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %5 |
| Kamuoyu < 30 | +%10 |
| Prestij < 20 | +%5 |
| Son 3 turda savaş kaybı | +%8 |
| Ekonomik kriz aktif | +%5 |
| Askeri harcama düşük | +%3 |
| Kamuoyu > 70 | -%5 |
| İç istikrar yüksek | -%8 |
| Güvenlik harcaması yüksek | -%10 |

*Örnek: Kamuoyu 25, Prestij 18, son savaş kayıp → %5 + %10 + %5 + %8 = %28 darbe riski*

---

**OLAY 2: EKONOMİK KRİZ**

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %3 |
| Bütçe açığı > 3 tur | +%15 |
| Yaptırım altında | +%10 |
| Ticaret anlaşması < 2 | +%8 |
| Savaş devam ediyor | +%5 |
| Küresel ekonomik şok | +%12 |
| Bütçe fazlası var | -%10 |
| Güçlü ticaret ağı (>4) | -%8 |
| Rezerv fonu var | -%15 |

---

**OLAY 3: TEKNOLOJİK ATILIM** (Pozitif)

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %8 |
| Ar-Ge yatırımı yüksek | +%15 |
| Eğitim harcaması yüksek | +%10 |
| Teknoloji anlaşması var | +%8 |
| İstikrar yüksek | +%5 |
| Beyin göçü yaşanıyor | -%12 |
| Ekonomik kriz | -%10 |
| İzolasyon (az ilişki) | -%8 |

---

**OLAY 4: HALK PROTESTOLARI**

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %5 |
| Kamuoyu < 40 | +%12 |
| Baskıcı politika aktif | +%10 |
| Ekonomik sıkıntı | +%8 |
| Komşuda devrim var | +%5 |
| İşsizlik yüksek | +%7 |
| Kamuoyu > 60 | -%10 |
| Refah yüksek | -%8 |
| Son dönem reform | -%10 |

---

**OLAY 5: VERİ SIZINTISI**

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %8 |
| Siber güvenlik düşük | +%15 |
| Siber saldırıya uğradı | +%20 |
| Çok gizli operasyon yapıyor | +%10 |
| Siber güvenlik yüksek | -%12 |
| Karşı istihbarat aktif | -%8 |

---

**OLAY 6: TERÖR SALDIRISI**

| Stat Durumu | Modifier |
|-------------|----------|
| Baz olasılık | %8 |
| Bölgesel kaos (savaş yakın) | +%12 |
| İstihbarat kapasitesi düşük | +%10 |
| Azınlık sorunu var | +%8 |
| Güvenlik harcaması düşük | +%7 |
| Güçlü istihbarat | -%10 |
| İç istikrar yüksek | -%8 |

---

**HESAPLAMA SÜRECİ (Her Tur Sonu):**

```
1. Her ülke için, her olayı kontrol et:
   
2. Ülkenin mevcut statlarını oku:
   - Kamuoyu: 45
   - Prestij: 25
   - Bütçe durumu: Açık
   - Aktif krizler: Yok
   - Son eylemler: Savaş kaybı var
   
3. Olay için tüm modifierleri hesapla:
   Darbe → Baz %5 + (prestij düşük: +%5) + (savaş kaybı: +%8) = %18
   
4. Zar at (1-100):
   - Zar ≤ 18 → Olay tetiklenir!
   - Zar > 18 → Bu tur olmaz
   
5. Tetiklenirse oyuncuya bildir ve seçenek sun
```

---

**OYUNCU TEPKİ SEÇENEKLERİ:**

Her olay tetiklendiğinde oyuncuya seçenekler sunulur:

```
🚨 DARBE GİRİŞİMİ TETİKLENDİ!

Seçenekler:
├── [A] Darbeyi bastır
│   └── Maliyet: 20 Askeri, Başarı: %70
│   └── Başarılı: Kriz biter, Prestij +10
│   └── Başarısız: Kriz devam, Askeri -%50
│
├── [B] Müzakere et
│   └── Maliyet: 10 Diplomasi, Başarı: %40
│   └── Başarılı: Kriz biter, reform zorunlu
│   └── Başarısız: Darbe başarılı olur
│
└── [C] Dış yardım iste
    └── Maliyet: 15 Prestij, Başarı: %60
    └── Başarılı: Müttefik müdahalesi
    └── Başarısız: Prestij kaybı, bağımlılık
```

---

**ÖZET TABLO: HANGI STAT HANGİ OLAYI ETKİLER**

| Stat | Arttırdığı Olaylar | Azalttığı Olaylar |
|------|-------------------|-------------------|
| Düşük Kamuoyu | Darbe, Protesto, Seçim Krizi | - |
| Düşük Prestij | Darbe, Skandal | - |
| Ekonomik Kriz | Darbe, Protesto | Teknoloji Atılımı |
| Düşük Siber Güvenlik | Veri Sızıntısı | - |
| Savaş/Kayıp | Darbe, Protesto | - |
| Yüksek Ar-Ge | - | Beyin Göçü; Teknoloji Atılımı+ |
| Yüksek İstikrar | - | Darbe, Protesto, Terör |
| Güçlü İstihbarat | - | Terör, Sızıntı |

#### 3. TEPKİSEL OLAYLAR (Oyuncu Aksiyonlarına Bağlı)

```javascript
// Oyuncu eylemi sonucu tetiklenen olaylar
trigger_conditions = {
  "REFUGEE_CRISIS": {
    "condition": "savaş başladığında",
    "affects": "komşu ülkeler",
    "effects": "ekonomi -5, iç karışıklık riski"
  },
  
  "ARMS_RACE": {
    "condition": "askeri yığınak tespit edildiğinde",
    "affects": "rakip ülkeler",
    "effects": "askeri harcama baskısı"
  },
  
  "TRADE_WAR": {
    "condition": "yaptırım uygulandığında",
    "affects": "ticaret partnerleri",
    "effects": "taraf seçme baskısı"
  },
  
  "DIPLOMATIC_INCIDENT": {
    "condition": "gizli operasyon ifşa olduğunda",
    "affects": "ilgili ülkeler",
    "effects": "ilişkiler kırılır"
  }
}
```

#### 4. ZİNCİR OLAYLAR

```
OLAY 1: Küçük ülkede iç savaş başlar
    ↓
OLAY 2: Mülteci krizi (komşular etkilenir)
    ↓
OLAY 3: İnsani yardım çağrısı (BM)
    ↓
OLAY 4: Büyük güçler müdahale kararı
    ↓
OLAY 5: Vekalet savaşı riski
```

---

## 🎯 GERÇEKÇİLİĞİ ARTIRMA (Detaylı)

### 1. ASİMETRİK BİLGİ SİSTEMİ

**Katmanlı Bilgi Erişimi:**

| Bilgi Türü | Kim Görür | Nasıl Elde Edilir |
|------------|-----------|-------------------|
| Kendi kaynakları | Herkes (kendi ekip) | Otomatik |
| Düşman askeri | Kimse | İstihbarat (10🕵️) |
| Gizli anlaşmalar | Taraflar | Sızıntı veya casus |
| Ekonomik veriler | Kısmi | Ticaret ilişkisi gerekli |
| Nükleer kapasite | Tahmin | İstihbarat + analiz |

**Sis (Fog of War) Mekanizması:**
```
Bilgi Doğruluk Oranı:
├── Kendi bilgilerin: %100
├── Müttefik bilgileri: %80
├── Nötr ülke: %50
├── Düşman: %20 (istihbaratsız)
└── Düşman: %70 (istihbaratlı)
```

### 2. ZAMAN BASKISI SİSTEMİ

**Kriz Zamanlayıcıları:**
```
NORMAL TUR: 30 dakika
KRİZ MODU: 10 dakika (ani olaylar için)
ACİL DURUM: 5 dakika (nükleer tehdit gibi)

Süre dolduğunda:
├── Karar verilmemişse → Varsayılan eylem
├── Anlaşma imzalanmamışsa → Müzakere çöker
└── Savunma yapılmamışsa → Saldırı başarılı
```

### 3. BELİRSİZLİK FAKTÖRLERİ

**Başarı Olasılıkları (Hiçbir şey garantili değil):**

| Eylem | Baz Başarı | Modifiyerler |
|-------|------------|--------------|
| Askeri operasyon | %60 | +istihbarat, +müttefik, -hava durumu |
| Gizli operasyon | %40 | +deneyim, -hedef güvenliği |
| Diplomasi | %70 | +ilişki geçmişi, -güvensizlik |
| Ekonomik operasyon | %80 | +kapasite, -piyasa durumu |

**Öngörülemeyen Yan Etkiler:**
```json
{
  "eylem": "Ekonomik yaptırım",
  "beklenen": "Hedef ekonomisi zarar görür",
  "olası_yan_etkiler": [
    {"event": "Hedef yeni müttefik bulur", "probability": "30%"},
    {"event": "Kendi şirketlerin zarar görür", "probability": "20%"},
    {"event": "Üçüncü ülke fırsat yakalar", "probability": "40%"},
    {"event": "Kaçakçılık artar", "probability": "50%"}
  ]
}
```

### 4. İTİBAR VE HAFIZA SİSTEMİ

**Güven Skoru (Her ülke çifti için):**
```
Güven Artıran:
├── Anlaşmalara uyma: +5
├── Kriz anında destek: +10
├── Ticaret: +2/tur
└── Ortak düşmana karşı işbirliği: +8

Güven Azaltan:
├── Anlaşmayı bozma: -20
├── Yalan söyleme (tespit edilirse): -15
├── Saldırganlık: -10
├── Sızıntı/casusluk: -25
```

**Güvenin Etkileri:**
```
Güven > 80: Otomatik istihbarat paylaşımı
Güven 50-80: Normal diplomasi
Güven 20-50: Her şey zor, maliyetli
Güven < 20: Diplomasi kanalları kapalı
```

### 5. İÇ POLİTİKA DENGESİ

**Kamuoyu Desteği:**
```
Başlangıç: 60/100

Artıran:
├── Ekonomik büyüme: +5
├── Diplomatik zafer: +10
├── Kriz yönetimi: +15
└── Prestij artışı: +3

Azaltan:
├── Savaş kayıpları: -15
├── Ekonomik kriz: -20
├── Skandal: -10
└── Dış baskıya boyun eğme: -8
```

**Kamuoyu Çok Düşükse (< 30):**
- Askeri operasyonlar zorlaşır
- Seçim krizi riski artar
- Darbe olasılığı artar
- Diplomatik gücün azalır

### 6. KAYNAK KISITLILIĞI

**Gerçekçi Kısıtlamalar:**
```
HER TUR:
├── Maksimum 3 büyük eylem
├── Bütçe: Harcama < Gelir olmalı (uzun vadede)
├── Askeri: Sürdürülebilirlik sınırı var
└── Dikkat: Her yere aynı anda odaklanamaz

SONUÇ:
├── Önceliklendirme zorunlu
├── Fırsat maliyeti her kararda var
└── Trade-off karar vermeyi zorlar
```

---

## 📋 2 GÜNLÜK SİMÜLASYON TAKVİMİ

### GÜN 1 (6 Saat - Ocak-Haziran 2025)

| Saat | Oyun Ayı | Odak | Organizatör Olayı |
|------|----------|------|-------------------|
| 0:00-0:30 | Ocak | Tanışma, strateji belirleme | - |
| 0:30-1:00 | Şubat | İlk diplomatik temaslar | - |
| 1:00-1:30 | Mart | İlk anlaşmalar | Ticaret fuarı |
| 1:30-2:00 | Nisan | Gerginlik işaretleri | Bölgesel çatışma haberi |
| 2:00-2:30 | Mayıs | İttifaklar netleşir | - |
| 2:30-3:00 | Haziran | Ara değerlendirme | **BÜYÜK KRİZ 1** |
| 3:00-3:30 | - | MOLA | - |
| 3:30-4:00 | Temmuz | Kriz tepkileri | - |
| 4:00-4:30 | Ağustos | Tırmanma veya yumuşama | Medya sızıntısı |
| 4:30-5:00 | Eylül | Sonuçlar | - |
| 5:00-5:30 | Ekim | Yeniden yapılanma | Ekonomik şok |
| 5:30-6:00 | Kasım-Aralık | 1. Gün kapanış | Yıl sonu değerlendirmesi |

### GÜN 2 (6 Saat - Ocak-Aralık 2026)

| Saat | Oyun Ayı | Odak | Organizatör Olayı |
|------|----------|------|-------------------|
| 0:00-0:30 | Ocak 2026 | Durum değerlendirme | - |
| 0:30-1:30 | Şubat-Nisan | Yoğun diplomasi | Teknoloji yarışı |
| 1:30-2:30 | Mayıs-Temmuz | Kritik kararlar | **BÜYÜK KRİZ 2** |
| 2:30-3:00 | - | MOLA | - |
| 3:00-4:00 | Ağustos-Ekim | Son hamleler | Sürpriz ittifak/ihanet |
| 4:00-5:00 | Kasım | Final aksiyonları | - |
| 5:00-5:30 | Aralık | Sonuç hesaplama | - |
| 5:30-6:00 | - | Değerlendirme, ödüller | - |

---

*Bu doküman, mekanik tasarımının temellerini içerir. Teknik implementasyon için ayrı bir spesifikasyon gerekecektir.*
