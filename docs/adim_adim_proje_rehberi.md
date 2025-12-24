# 🚀 Diplomasi Simülasyonu: Yeni Başlayanlar İçin Yol Haritası

Merhaba! Okuduğun o detaylı teknik dokümanlar gözünü korkutmasın. Her büyük yazılım projesi, aslında üst üste konmuş küçük parçalardan oluşur. Bu projeyi bir LEGO seti gibi düşünebilirsin.

İşte bu "canavarı" evcilleştirip adım adım hayata geçirme planın:

---

## 🏁 1. Altın Kural: "Önce En Basiti Yap" (MVP)

Hemen "İstihbarat Teşkilatı", "Siber Saldırılar" veya "Karmaşık Zar Sistemleri"ni kodlamaya çalışma.

**İlk Hedefin Şu Olsun:**
> "Ekranda bir ülke olsun, 'Vergi Topla' butonuna basınca parası 10 artsın."

Bunu başardığında projenin %20'si bitmiş demektir, çünkü temel bağlantıyı kurdun!

---

## 🗺️ Adım Adım İlerleme Planı

### Adım 1: Veri Yapısını Kur (İskelet)
Kod yazmadan önce, oyunun "hafızasını" tasarlamalıyız. Bir JSON dosyası veya basit bir veritabanı tablosu düşün.

Bir ülkeyi bilgisayarın anlayacağı dilde tanımla:
```json
{
  "ulke_adi": "Türkiye",
  "butce": 100,
  "askeri_guc": 50,
  "halk_mutlulugu": 60
}
```
*Bunu 8 ülke için yaptığında oyunun temeli hazır.*

### Adım 2: Beyni Kodla (Backend)
Oyunun kurallarının çalışacağı yer burası. `Node.js` kullanacağız.
Basit bir fonksiyon yazacaksın:

*   **Girdi:** Oyuncu "Asker Eğit" butonuna bastı.
*   **İşlem:** Bütçeden 10 düş, Askeri Güce 5 ekle.
*   **Kontrol:** Parası yetiyor mu? (Basit bir `if` sorgusu).
*   **Çıktı:** Yeni durumu kaydet.

### Adım 3: Yüzü Tasarla (Frontend)
Kullanıcıların göreceği ekran. `Next.js` (React) kullanacağız çünkü yapboz gibi parça parça (Bileşen/Component) çalışır.

*   Önce sadece bir **"Dashboard"** yap.
*   Ekranda kocaman "BÜTÇENİZ: 100" yazsın.
*   Yanına bir buton koy: "Asker Üret".

### Adım 4: Beyin ve Yüzü Konuştur (API Bağlantısı)
Şu an beynin ayrı, yüzün ayrı yerde. Onları birleştireceğiz.

*   Butona basılınca Frontend, Backend'e bir mesaj atacak: *"Hey, asker üretmek istiyoruz!"*
*   Backend işlemi yapıp cevap verecek: *"Tamam, yeni bütçe 90, yeni asker 55."*
*   Frontend ekranı güncelleyecek.

### Adım 5: Gerçek Zamanlı Hale Getir (Socket.io)
İşte işin sihirli kısmı.
Normal web sitelerinde sayfayı yenilemen gerekir. Ama burada olaylar anlık olmalı.

*   `Socket.io` kütüphanesini bir "WhatsApp Grubu" gibi düşün.
*   Biri savaş ilan ettiğinde, sunucu bu gruba mesaj atar: *"DİKKAT! Savaş Başladı!"*
*   Tüm bağlı bilgisayarlar bu mesajı alır ve ekranlarında kırmızı bir uyarı çıkarır.

---

## 💡 Amatör Geliştirici İçin Tavsiyeler

1.  **Görselliğe Takılma:** Harita, bayraklar, efektler... Bunlar en son iş. Gerekirse her şey sadece metin ve buton olsun. Önemli olan "Savaş" butonuna basınca sayıların doğru düşmesi.
2.  **Yapay Zeka Kullan:** Kod yazarken takıldığında AI'a (bana veya başkasına) şunu sor: *"Node.js ile basit bir bütçe düşme fonksiyonu nasıl yazarım?"* Parça parça sor.
3.  **Hata Yapmaktan Korkma:** Veritabanını bozacaksın, sunucuyu çökerteceksin. Bu öğrenmenin en iyi yoludur. "Localhost"ta (kendi bilgisayarında) olduğun sürece hiçbir şeyi kıramazsın.
4.  **Log Tut:** Kodun içine bol bol `console.log("Buraya girdi", "Para şu kadar oldu")` yaz. Kodun nerede hata verdiğini böyle anlarsın.

---

## 🛠️ Çantanda Neler Olacak? (Teknolojiler)

*   **Dil:** JavaScript (Hem ön hem arka taraf için tek dil, kafan karışmaz).
*   **Frontend:** Next.js (Modern ve popüler).
*   **Backend:** Node.js (Hızlı ve basit).
*   **Veritabanı:** Başlangıçta basit bir `data.json` dosyası bile yeter. Sonra veritabanına geçeriz.

Başlamaya hazır mısın? "Hadi kuruluma başlayalım" dediğinde sana ilk kodlarını vereceğim!
