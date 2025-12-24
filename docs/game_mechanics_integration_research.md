# 🎮 Oyun Mekanikleri Entegrasyon Araştırması

**Kaynak Oyunlar:** D&D 5e, Europa Universalis 4, Hearts of Iron 4, Civilization 6  
**Hedef:** 60-80 kişilik diplomasi simülasyonu için entegre edilebilecek mekanikler

---

## 📊 OYUN MEKANİKLERİ KARŞILAŞTIRMA MATRİSİ

| Mekanik | D&D | EU4 | HOI4 | Civ6 | Simülasyona Uygunluk |
|---------|-----|-----|------|------|---------------------|
| Zar/Olasılık Sistemi | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ | YÜKSEK |
| Kaynak Yönetimi | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | YÜKSEK |
| Diplomasi Puanı | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | YÜKSEK |
| Casus Belli | - | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ÇOK YÜKSEK |
| Odak Ağacı | - | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ORTA |
| Şikayet/İtibar | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ÇOK YÜKSEK |
| Ticaret Sistemi | - | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | YÜKSEK |
| Dünya Gerilimi | - | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ÇOK YÜKSEK |

---

## 🎲 D&D 5e MEKANİKLERİ

### 1. Avantaj / Dezavantaj Sistemi

**Orijinal Mekanik:**
- Avantaj: 2d20 at, yüksek olanı al
- Dezavantaj: 2d20 at, düşük olanı al
- Birden fazla kaynak birbirini iptal eder

**Simülasyona Entegrasyon:**

```
OPERASYON BAŞARI HESAPLAMA:

Baz Başarı: %50

AVANTAJ KAYNAKLARI (+%15 her biri):
├── İstihbarat desteği var
├── Müttefik yardımı var
├── Teknolojik üstünlük
├── Sürpriz faktörü
└── İç istikrar yüksek

DEZAVANTAJ KAYNAKLARI (-%15 her biri):
├── Hedef ülke uyarılmış
├── Kötü hava/coğrafya
├── Düşük moral
├── Kaynak yetersizliği
└── İç karışıklık

HESAPLAMA:
Avantaj sayısı > Dezavantaj sayısı → +%20 net bonus
Dezavantaj sayısı > Avantaj sayısı → -%20 net ceza
Eşit → Normal hesaplama
```

**Somut Örnek - Siber Saldırı:**
```
ABD → Rusya'ya siber saldırı

Baz Başarı: %50
+ ABD siber uzmanlığı: +%15
+ İstihbarat var: +%15
- Rusya uyarıldı: -%15
- Rusya savunması güçlü: -%15

Net: %50 (avantaj ve dezavantaj dengelendi)

Zar Simülasyonu: Sistem 1-100 arasında rastgele sayı üretir
≤50 = Başarılı
>50 = Başarısız
```

---

### 2. Skill Check (Yetenek Kontrolü) Sistemi

**Orijinal Mekanik:**
- d20 + Yetenek Modifiyeri + Uzmanlık Bonusu ≥ Zorluk Derecesi (DC)

**Simülasyona Entegrasyon:**

```
EYLEM ZORLUK DERECELERİ:

Kolay (DC 10 / %70):
├── Dostane ülkeyle anlaşma
├── Müttefike bilgi paylaşımı
└── İç politika değişikliği

Orta (DC 15 / %50):
├── Nötr ülkeyle anlaşma
├── Gizli istihbarat operasyonu
└── Ekonomik yaptırım

Zor (DC 20 / %30):
├── Düşman ülkeyle müzakere
├── Siber saldırı
└── Rejim değişikliği operasyonu

Çok Zor (DC 25 / %15):
├── Süper güce karşı operasyon
├── Çok taraflı koalisyon kurma
└── Küresel anlaşma

Neredeyse İmkansız (DC 30 / %5):
├── BM'de veto'yu aşma
├── Nükleer güce karşı savaş kazanma
└── Küresel hegemonyayı yıkma
```

**Her Ülke İçin Uzmanlık Bonusları:**

| Ülke | Uzmanlık Alanı | Bonus |
|------|---------------|-------|
| ABD | Askeri Operasyonlar, Siber | +%15 |
| Rusya | Dezenformasyon, Enerji | +%15 |
| Çin | Ekonomi, Uzun Vade Planlama | +%15 |
| Türkiye | Arabuluculuk, Coğrafi Konum | +%15 |
| AB | Diplomasi, Yumuşak Güç | +%15 |
| Hindistan | Nüfus, Teknoloji | +%15 |
| S. Arabistan | Enerji, Finans | +%15 |
| İsrail | İstihbarat, Askeri Teknoloji | +%15 |

---

### 3. Inspiration (İlham) Sistemi

**Orijinal Mekanik:**
- DM, iyi rol yapma için Inspiration verir
- Kullanıldığında bir atışta avantaj sağlar

**Simülasyona Entegrasyon:**

```
"ULUSAL MOMENTUM" SİSTEMİ

Kazanma Yolları:
├── Yaratıcı diplomasi hamlesi: +1 Momentum
├── Başarılı kriz yönetimi: +1 Momentum
├── Müttefik kurtarma: +1 Momentum
├── Prestijli anlaşma: +1 Momentum
└── Organizatör takdiri: +1 Momentum

Kullanım:
├── 1 Momentum = Bir operasyonda %25 bonus
├── 2 Momentum = Başarısız operasyonu yeniden dene
└── 3 Momentum = Kritik başarı garantisi (tek seferlik)

Kısıtlama:
└── Maksimum 3 Momentum biriktirilebilir
```

---

## 🗺️ EUROPA UNIVERSALIS 4 MEKANİKLERİ

### 1. Casus Belli (Savaş Sebebi) Sistemi

**Orijinal Mekanik:**
- Savaş için geçerli sebep gerekli
- Sebepsiz savaş = Stabilite kaybı + Agresif Genişleme cezası
- Farklı CB türleri farklı hedefler ve maliyetler sunar

**Simülasyona Entegrasyon:**

```
SAVAŞ SEBEBİ TABLOSU:

┌─────────────────────────────────────────────────────────────────┐
│                     CASUS BELLİ TÜRLERİ                         │
├─────────────────┬─────────────┬─────────────┬───────────────────┤
│ Sebep           │ Nasıl Elde  │ Prestij     │ İzin Verilen      │
│                 │ Edilir      │ Maliyeti    │ Barış Şartları    │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Sınır İhlali    │ Otomatik    │ Düşük       │ Tazminat, Özür    │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Saldırganlık    │ Rakip       │ Düşük       │ Toprak, Tazminat  │
│ (Savunma)       │ saldırınca  │             │                   │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Yayılmacılık    │ Hedefin AE  │ Orta        │ Sınırlı Toprak    │
│ Karşıtı         │ yüksekse    │             │                   │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Müttefik        │ Müttefiğe   │ Düşük       │ Statüko, Tazminat │
│ Savunması       │ saldırı     │             │                   │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Bağımsızlık     │ Azınlık     │ Orta        │ Yeni Devlet       │
│ Destekleme      │ hareketleri │             │ Kurulması         │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ İnsani Müdahale │ Soykırım/   │ Düşük       │ Rejim Değişikliği │
│                 │ Kriz        │             │                   │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ Terörle Mücadele│ Terör       │ Düşük       │ Askeri Üs, İşgal  │
│                 │ saldırısı   │             │                   │
├─────────────────┼─────────────┼─────────────┼───────────────────┤
│ SEBEBSİZ SAVAŞ  │ -           │ ÇOK YÜKSEK  │ Her şey ama       │
│                 │             │ (-%30)      │ herkes düşman olur│
└─────────────────┴─────────────┴─────────────┴───────────────────┘
```

**Casus Belli Üretme Yolları:**

```javascript
// Oyuncular CB oluşturabilir
cb_fabrication = {
  "istihbarat_operasyonu": {
    "cost": "15 İstihbarat",
    "duration": "2 tur",
    "success_chance": "60%",
    "produces": "İddia/Provokasyon CB",
    "risk": "Yakalanırsa prestij -20"
  },
  
  "diplomatik_olay_yaratma": {
    "cost": "10 Diplomasi",
    "duration": "1 tur", 
    "success_chance": "40%",
    "produces": "Diplomatik Hakaret CB",
    "risk": "Başarısızlık = İlişki -15"
  },
  
  "medya_kampanyası": {
    "cost": "20 Bütçe",
    "duration": "3 tur",
    "success_chance": "70%",
    "produces": "Kamuoyu Desteği CB",
    "risk": "Karşı propaganda"
  }
}
```

---

### 2. Agresif Genişleme (AE) ve Koalisyon Sistemi

**Orijinal Mekanik:**
- Her toprak ilhakı Agresif Genişleme puanı üretir
- Yüksek AE = Diğer ülkeler koalisyon kurar
- AE zamanla azalır

**Simülasyona Entegrasyon:**

```
AGRESİF GENIŞLEME SİSTEMİ

Eylem                          │ AE Kazanımı
───────────────────────────────┼────────────
Sebepsiz savaş ilanı           │ +50
Sebepli savaş ilanı            │ +20
Toprak ilhakı (küçük)          │ +15
Toprak ilhakı (büyük)          │ +30
Şehir işgali                   │ +25
Sivil kayıplar                 │ +40
Nükleer tehdit                 │ +60
Uluslararası hukuk ihlali      │ +35
Anlaşma ihlali                 │ +45

KOALİSYON TEHDİT SEVİYELERİ:

AE < 50:   GÜVENLI
           └── Minimal diplomatik tepki

AE 50-100: DİKKAT
           ├── Diğer ülkelerde uyarı
           └── BM gündemi

AE 100-150: TEHLİKE
           ├── Ekonomik yaptırımlar başlayabilir
           └── Müttefikler mesafeler

AE 150-200: KRİTİK
           ├── Koalisyon oluşumu başlar
           └── Ticaret anlaşmaları bozulur

AE > 200: DÜŞMAN İLAN
           ├── Tüm ülkeler karşı koalisyonda
           └── Tam ekonomik abluka
           
AE AZALMASI:
├── Her tur: -5 AE
├── Barış anlaşması: -20 AE
├── İnsani yardım: -10 AE
└── Toprak iadesi: -15 AE
```

---

### 3. Favor (İyilik) Sistemi

**Orijinal Mekanik:**
- Müttefiklerle etkileşim iyilik puanı biriktirir
- İyilik puanı ile müttefikleri savaşa çağırabilirsin

**Simülasyona Entegrasyon:**

```
İYİLİK/BORÇ SİSTEMİ

Her ülke çifti için iyilik puanı takibi:

┌─────────────────────────────────────────────────────────┐
│ TÜRKİYE - ABD İLİŞKİ TABLOSU                            │
├─────────────────────────────────────────────────────────┤
│ Türkiye'nin ABD'ye borcu: 15 puan                       │
│ ABD'nin Türkiye'ye borcu: 8 puan                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ İYİLİK KAZANMA:                                          │
│ ├── Ticaret bonusu verme: +3                            │
│ ├── İstihbarat paylaşımı: +5                            │
│ ├── Krizde destek: +10                                  │
│ ├── Ortak düşmana karşı savaş: +15                      │
│ └── Toprak/kaynak hediyesi: +20                         │
│                                                          │
│ İYİLİK HARCAMA:                                          │
│ ├── Savaşa destek çağrısı: 20 puan                      │
│ ├── Ekonomik yardım talebi: 10 puan                     │
│ ├── BM'de oy desteği: 5 puan                            │
│ └── İstihbarat paylaşımı talebi: 8 puan                 │
│                                                          │
│ RED DURUMUNDA:                                           │
│ └── İyilik puanı varsa red prestij kaybettirir          │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

### 4. Ticaret Düğümü Sistemi

**Orijinal Mekanik:**
- Ticaret düğümlerinden geçen zenginlik
- Yönlendirme vs toplama kararı
- Son düğümlere (end nodes) akış

**Simülasyona Entegrasyon:**

```
EKONOMİK ETKİ ALANLARI

                    ┌─────────┐
                    │  KÜRESEL │
                    │ FİNANS  │
                    │(Londra, │
                    │ NY, HK) │
                    └────┬────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
    │  AVRUPA  │    │  ASYA   │    │ AMERİKA │
    │ TİCARET  │    │ TİCARET │    │ TİCARET │
    └────┬────┘    └────┬────┘    └────┬────┘
         │               │               │
    ┌────▼────┐    ┌────▼────┐    ┌────▼────┐
    │ ORTADOĞU│    │ GÜNEYDOĞU    │ LATİN   │
    │ ENERJİ  │    │ ASYA    │    │ AMERİKA │
    └─────────┘    └─────────┘    └─────────┘

TİCARET GÜCÜ HESAPLAMA:

Ülke Ticaret Gücü = Ekonomi Kaynağı + 
                    Ticaret Anlaşmaları Bonusu +
                    Stratejik Konum Bonusu

DÜĞÜM KONTROL ETKİSİ:
├── >%50 kontrol = Düğümden tam gelir
├── %30-50 kontrol = Kısmi gelir
└── <%30 kontrol = Minimal gelir

YAPTIRIMLARIN ETKİSİ:
Ticaret düğümünden dışlama = O bölgeden gelir yok
```

---

## ⚙️ HEARTS OF IRON 4 MEKANİKLERİ

### 1. National Focus Tree (Ulusal Odak Ağacı)

**Orijinal Mekanik:**
- Ülkenin gelişim yolunu belirleyen odak sistemi
- Her odak zaman ve politik güç gerektirir
- Bazı odaklar birbirini dışlar

**Simülasyona Entegrasyon:**

```
ÜLKE STRATEJİ AĞACI

Her ülke oyun başında bir "ana strateji" seçer:

┌─────────────────────────────────────────────────────────────────┐
│                    TÜRKİYE ODAK AĞACI                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                        [BAŞLANGIÇ]                               │
│                             │                                    │
│              ┌──────────────┼──────────────┐                    │
│              ▼              ▼              ▼                    │
│      ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│      │ BATI BLOKU  │ │  BAĞIMSIZ   │ │DOĞU EĞİLİMİ │           │
│      │ ENTEGRASYON │ │   GÜÇ       │ │             │           │
│      └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│             │               │               │                    │
│      ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐           │
│      │ NATO Güçlen-│ │ Bölgesel    │ │ Avrasya     │           │
│      │ dirmesi     │ │ Liderlik    │ │ İşbirliği   │           │
│      │ (+Askeri)   │ │ (+Prestij)  │ │ (+Ekonomi)  │           │
│      └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│             │               │               │                    │
│      ┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐           │
│      │ AB Üyelik   │ │ Arabulucu   │ │ Şanghay     │           │
│      │ Yolu        │ │ Devlet      │ │ İşbirliği   │           │
│      │ (+Ekonomi)  │ │ (+Diplomasi)│ │ (+Ticaret)  │           │
│      └─────────────┘ └─────────────┘ └─────────────┘           │
│                                                                  │
│  [!] Bir yol seçildiğinde diğerleri kapanır                     │
│  [!] Her odak tamamlanması için 1 tur + kaynak gerektirir       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Odak Tamamlama Etkileri:**

| Odak | Maliyet | Kazanım |
|------|---------|---------|
| Batı Bloku Entegrasyon | 20💰 + 1 tur | NATO'dan +10⚔️, ABD ile +20 ilişki |
| Bölgesel Liderlik | 15📊 + 1 tur | Komşularla +10 ilişki, +15 diplomasi puanı |
| Doğu Eğilimi | 15💰 + 1 tur | Rusya/Çin ile +15 ilişki, enerji indirimi |

---

### 2. World Tension (Dünya Gerilimi) Sistemi

**Orijinal Mekanik:**
- Global gerilim ölçer (0-100%)
- Belirli eylemleri sadece belirli gerilimde yapabilirsin
- Demokratik ülkeler yüksek gerilim gerektirir

**Simülasyona Entegrasyon:**

```
KÜRESEL GERİLİM ÖLÇER

░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 0%
████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 10%
████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ 30%
████████████████████░░░░░░░░░░░░░░░░░░░░░░░ 50%
████████████████████████████░░░░░░░░░░░░░░░ 70%
████████████████████████████████████████░░░ 90%
█████████████████████████████████████████ 100%

GERİLİM ARTIRAN EYLEMLER:
├── Savaş ilanı: +15-25%
├── Askeri yığınak: +5%
├── CB fabrication yakalanma: +3%
├── Nükleer test/tehdit: +20%
├── Anlaşma ihlali: +10%
└── Toprak ilhakı: +10%

GERİLİM AZALTAN EYLEMLER:
├── Barış anlaşması: -10%
├── Silahsızlanma: -5%
├── Uluslararası toplantı: -3%
└── Her barış turu: -2%

GERİLİME GÖRE İZİN VERİLEN EYLEMLER:

%0-25 (Soğuk Barış):
├── Normal diplomasi
├── Ticaret anlaşmaları
└── Gizli operasyonlar (riskli)

%25-50 (Gerginlik):
├── Müttefik savunması
├── Yaptırımlar
└── Askeri tatbikatlar

%50-75 (Kriz):
├── Savaş ilanı mümkün
├── Koalisyon kurma
└── Acil askerileşme

%75-100 (Savaş Eşiği):
├── Topyekün savaş
├── Nükleer opsiyon
└── Dünya savaşı riski
```

---

### 3. Political Power (Politik Güç) Sistemi

**Orijinal Mekanik:**
- Günlük biriken kaynak
- Danışman atama, kanun değiştirme, odak aktivasyonu için kullanılır

**Simülasyona Entegrasyon:**

```
POLİTİK SERMAYE SİSTEMİ

Her tur +10 Politik Sermaye kazanılır

Modifiyerler:
├── Yüksek iç istikrar: +5
├── Ekonomik büyüme: +3
├── Başarılı diplomasi: +5
├── Düşük kamuoyu desteği: -5
├── İç kriz: -10
└── Savaş yorgunluğu: -8

HARCAMA ALANLARI:

┌─────────────────────────────────────────┐
│ Eylem                    │ Maliyet      │
├──────────────────────────┼──────────────┤
│ Danışman değiştirme      │ 15 PS        │
│ Kanun değişikliği        │ 20 PS        │
│ Acil toplantı çağrısı    │ 10 PS        │
│ Kriz müdahalesi          │ 25 PS        │
│ Ulusal seferberlik       │ 50 PS        │
│ Referandum               │ 30 PS        │
└──────────────────────────┴──────────────┘
```

---

## 🏛️ CIVILIZATION 6 MEKANİKLERİ

### 1. Grievances (Şikayet) Sistemi

**Orijinal Mekanik:**
- Agresif eylemlere karşı biriken olumsuz puan
- Şikayetler zamanla azalır
- Yüksek şikayet = Diğer ülkeler düşmanca davranır

**Simülasyona Entegrasyon:**

```
ŞİKAYET SİSTEMİ

Her ülke çifti için ayrı şikayet puanı:

ŞİKAYET KAZANDIRAN EYLEMLER:
┌────────────────────────────┬─────────────┐
│ Eylem                      │ Şikayet     │
├────────────────────────────┼─────────────┤
│ Sürpriz savaş ilanı        │ +150        │
│ Resmi savaş ilanı          │ +100        │
│ Meşru savunma savaşı       │ +25         │
│ Şehir işgali               │ +25/şehir   │
│ Şehir yıkımı               │ +200        │
│ Anlaşma ihlali             │ +100        │
│ Yaptırım                   │ +30         │
│ Casusluk (yakalanmış)      │ +50         │
│ Din/kültür yayma           │ +10         │
│ Kınama                     │ +25         │
│ Söz verip tutmama          │ +75         │
└────────────────────────────┴─────────────┘

ŞİKAYET ETKİLERİ:

0-50: Normal ilişkiler
50-100: Soğuk ilişkiler (diplomasi maliyeti +%25)
100-200: Düşmanca (anlaşma zor, yaptırım riski)
200-300: Savaş eşiği (karşı taraf meşru savaş hakkı kazanır)
300+: Düşman ilan (tüm ilişkiler kesilir)

ŞİKAYET AZALMASI:
├── Her tur: -5 şikayet
├── Olumlu eylem: -10 şikayet
├── Tazminat ödeme: -30 şikayet
├── Toprak iade: -50 şikayet
└── Resmi özür: -20 şikayet

ÖNEMLİ: Şikayet puanı KARŞILIKLI MİSİLLEME hakkı verir!
Örnek: Rusya'nın size 80 şikayeti varsa, siz Rusya'ya 
karşı 80 şikayete kadar eylem yapabilirsiniz CEZASIZ.
```

---

### 2. Diplomatic Favor (Diplomasi Puanı) Sistemi

**Orijinal Mekanik:**
- Uluslararası toplantılarda oy kullanmak için harcanan puan
- İttifaklar ve iyi ilişkilerden kazanılır
- Diplomatik zafer için gerekli

**Simülasyona Entegrasyon:**

```
DİPLOMASİ PUANI SİSTEMİ

KAZANMA YOLLARI:
┌────────────────────────────┬───────────────┐
│ Kaynak                     │ Puan/Tur      │
├────────────────────────────┼───────────────┤
│ Temel (hükümet var)        │ +1            │
│ Her ittifak                │ +2            │
│ Her ticaret anlaşması      │ +1            │
│ Başarılı arabuluculuk      │ +10 (tek sef) │
│ Kurtarma operasyonu        │ +15 (tek sef) │
│ İnsani yardım              │ +5 (tek sef)  │
│ Yarışma/Turnuva kazanma    │ +10 (tek sef) │
└────────────────────────────┴───────────────┘

TEK SEFERLIK BONUSLAR:
├── Bir ülkeyi işgalden kurtar: +30
├── Barış anlaşması aracılığı: +20
├── Küresel kriz çözümü: +25
└── BM'de başarılı karar: +15

HARCAMA ALANLARI:

BM / ULUSLARARASI OYLAMA:
├── 1 oy = 5 diplomasi puanı
├── Veto'yu aşma girişimi = 50 diplomasi puanı
└── Acil toplantı çağrısı = 20 diplomasi puanı

DİĞER KULLANIMLAR:
├── Ticaret pazarlığında avantaj: 10 puan
├── Anlaşma şartlarını değiştirme: 15 puan
└── Müttefik çağırma: 20 puan
```

---

### 3. Emergency & Competition (Acil Durum & Yarışma) Sistemi

**Orijinal Mekanik:**
- Belirli olaylar acil durum/rekabet başlatır
- Katılan ülkeler hedefe ulaşırsa ödül alır
- İşbirliği veya rekabet ortamı yaratır

**Simülasyona Entegrasyon:**

```
KÜRESEL ETKİNLİK SİSTEMİ

TÜR 1: ACİL DURUMLAR (İşbirliği gerektirir)

Örnek: "İnsani Kriz - Suriye"
┌──────────────────────────────────────────────────────┐
│ HEDEF: 100 İnsani Yardım Puanı toplamak (3 tur)      │
├──────────────────────────────────────────────────────┤
│ Katılım: İsteğe bağlı                                │
│ Katkı: Her 10💰 = 5 İnsani Yardım Puanı              │
│                                                       │
│ BAŞARI ÖDÜLÜ (hedefe ulaşılırsa):                    │
│ ├── Tüm katılımcılara +15 Diplomasi Puanı            │
│ ├── En çok katkıya +30 Prestij                       │
│ └── Bölgede etki alanı                               │
│                                                       │
│ BAŞARISIZLIK (hedefe ulaşılamazsa):                  │
│ ├── Küresel gerilim +10%                             │
│ └── Katılmayanlara -10 Prestij                       │
└──────────────────────────────────────────────────────┘

TÜR 2: YARIŞMALAR (Rekabet)

Örnek: "Uzay Yarışı"
┌──────────────────────────────────────────────────────┐
│ HEDEF: En çok Teknoloji Puanı toplayan kazanır       │
├──────────────────────────────────────────────────────┤
│ Süre: 5 tur                                          │
│ Katkı: Araştırma yatırımları                         │
│                                                       │
│ ÖDÜLLER:                                             │
│ ├── 1. sıra: +50 Prestij, Teknoloji bonusu           │
│ ├── 2. sıra: +25 Prestij                             │
│ └── 3. sıra: +10 Prestij                             │
└──────────────────────────────────────────────────────┘
```

---

## 🔧 ENTEGRE SİSTEM ÖNERİSİ

### Tüm Mekaniklerin Birleşimi

```
DİPLOMASİ SİMÜLASYONU - ENTEGRE SİSTEM

1. EYLEM BAŞLATMA
   └── Oyuncu bir eylem seçer (örn: Siber saldırı)

2. MALİYET KONTROLÜ
   ├── Kaynak yeterli mi? (EU4/HOI4)
   ├── Casus Belli var mı? (EU4)
   └── Dünya Gerilimi izin veriyor mu? (HOI4)

3. BAŞARI HESABI
   ├── Baz başarı şansı belirlenir (D&D DC)
   ├── Avantaj/Dezavantaj eklenir (D&D)
   ├── Uzmanlık bonusu eklenir (D&D)
   └── Zar simülasyonu yapılır (D&D)

4. SONUÇ İŞLEME
   ├── Başarı → Hedef etki uygulanır
   ├── Başarısızlık → Kaynak kaybı + olası tepki
   └── Kritik → 2x etki veya felaket

5. DÜNYA ETKİSİ
   ├── Şikayet puanları güncellenir (Civ6)
   ├── Agresif Genişleme hesaplanır (EU4)
   ├── Dünya Gerilimi güncellenir (HOI4)
   └── Diplomasi Puanı değişir (Civ6)

6. TEPKİ DÖNEMİ
   ├── Etkilenen ülkeler tepki verebilir
   ├── Koalisyon kontrolü (EU4)
   └── Müttefik çağrısı değerlendirmesi (EU4)
```

---

## 📱 SOMUT UI ÖNERİLERİ

### Eylem Onay Ekranı

```
┌──────────────────────────────────────────────────────────────┐
│                    🎯 SİBER SALDIRI                          │
│                    Hedef: Rusya Enerji Altyapısı             │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  MALİYET:                                                     │
│  ├── 15 İstihbarat Puanı ✓                                   │
│  └── 10 Bütçe ✓                                              │
│                                                               │
│  BAŞARI ŞANSI:                                                │
│  ├── Baz: 50%                                                │
│  ├── + ABD Siber Uzmanlığı: +15%                             │
│  ├── + İstihbarat Avantajı: +10%                             │
│  ├── - Rusya Savunması: -10%                                 │
│  └── = TOPLAM: 65%                                           │
│                                                               │
│  ┌────────────────────────────────────────────────────┐      │
│  │ ██████████████████████████░░░░░░░░░░░░ 65%         │      │
│  └────────────────────────────────────────────────────┘      │
│                                                               │
│  OLASI SONUÇLAR:                                              │
│  ├── ✓ Başarı: Rusya enerji üretimi -20%                     │
│  ├── ✗ Başarısızlık: Kaynak kaybı + ifşa riski               │
│  └── ☠ Kritik Başarısızlık: Uluslararası kriz                │
│                                                               │
│  DİPLOMATİK ETKİ:                                             │
│  ├── Rusya Şikayeti: +50                                     │
│  ├── Dünya Gerilimi: +5%                                     │
│  └── Yakalanırsa: Prestij -20                                │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐                          │
│  │   ONAYLA 🎲  │  │    İPTAL     │                          │
│  └──────────────┘  └──────────────┘                          │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### Zar Atma Animasyonu (Onay Sonrası)

```
┌──────────────────────────────────────────────────────────────┐
│                                                               │
│                    🎲 OPERASYON BAŞLIYOR                     │
│                                                               │
│                        65%                                    │
│                    Başarı Şansı                               │
│                                                               │
│                    ┌─────────┐                                │
│                    │         │                                │
│                    │   42    │  ← Atılan Sayı                │
│                    │         │                                │
│                    └─────────┘                                │
│                                                               │
│                    ✅ BAŞARILI!                               │
│                    (42 ≤ 65)                                  │
│                                                               │
│  Rusya enerji altyapısı hasar gördü.                         │
│  Enerji üretimi -%20 düştü.                                  │
│                                                               │
│  ┌──────────────┐                                            │
│  │    DEVAM     │                                            │
│  └──────────────┘                                            │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

---

## ✅ ÖZET: HANGİ MEKANİK NEREDEN?

| Mekanik | Kaynak | Simülasyondaki Rolü |
|---------|--------|---------------------|
| Avantaj/Dezavantaj | D&D | Operasyon başarı hesabı |
| Skill Check + DC | D&D | Zorluk dereceleri |
| Inspiration | D&D | Ulusal Momentum bonusu |
| Casus Belli | EU4 | Meşru savaş gerekçesi |
| Agresif Genişleme | EU4 | Saldırganlık cezası |
| Favor | EU4 | Müttefik borç/alacak |
| Ticaret Düğümleri | EU4 | Ekonomik etki alanları |
| National Focus | HOI4 | Ülke strateji ağacı |
| World Tension | HOI4 | Küresel gerilim ölçer |
| Political Power | HOI4 | Günlük biriken kaynak |
| Grievances | Civ6 | Şikayet/öfke puanı |
| Diplomatic Favor | Civ6 | BM oylama puanı |
| Emergencies | Civ6 | Küresel etkinlikler |

---

*Bu araştırma dokümanı, D&D, EU4, HOI4 ve Civ6 oyun mekaniklerinin diplomasi simülasyonuna entegrasyonu için kapsamlı bir rehber niteliğindedir.*
