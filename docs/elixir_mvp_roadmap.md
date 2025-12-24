# 🧪 Diplomasi Simülasyonu - Elixir & Phoenix LiveView MVP Planı

**Karar Verilen Mimari:**
*   **Dil:** Elixir (Erlang VM üzerinde) - *Yüksek hata toleransı ve eşzamanlılık için.*
*   **Web Framework:** Phoenix - *Modern web standartları.*
*   **Frontend/Etkileşim:** Phoenix LiveView - *React yazmadan, sunucu taraflı render ile SPA deneyimi.*
*   **Stil:** Tailwind CSS - *Hızlı ve modern UI tasarımı.*
*   **Veritabanı:** PostgreSQL.
*   **Gerçek Zamanlı İletişim:** Phoenix PubSub (WebSocket).

---

## 🎯 MVP (Minimum Çalışan Ürün) Tanımı
**Amaç:** Sistemin "canlı" olduğunu kanıtlamak.
**Kapsam:**
1.  **Ülke Paneli:** Kullanıcı ülkesinin bütçesini ve asker sayısını görür.
2.  **Etkileşim:** "Vergi Topla" butonuna basar, sunucuda işlem yapılır, bütçe artar.
3.  **Real-Time:** Sayfa yenilenmeden (F5 atmadan) bütçe güncellenir.
4.  **Veri Kalıcılığı:** Sayfayı kapatıp açsa bile veriler veritabanında saklanır.

---

## 🤖 Gemini'nin (Agent) Görev Listesi

Benim (Yapay Zeka) yapacağım işlemler adım adım şunlardır:

### 1. Hazırlık ve Altyapı
*   [ ] **Docker Compose Hazırlığı:** Senin bilgisayarına Elixir ve Postgres kurmakla uğraşmaman için projeyi Docker içinde çalışacak şekilde ayarlayacağım (`docker-compose.yml` ve `Dockerfile`).
*   [ ] **Phoenix Projesi Oluşturma:** Gerekli komutları çalıştırıp iskelet dosyaları oluşturacağım.

### 2. Veritabanı ve Mantık (Backend)
*   [ ] **Migration Oluşturma:** `countries` tablosunu veritabanına tanıtacağım.
*   [ ] **Schema Tanımı:** Elixir tarafında `Country` veri modelini yazacağım.
*   [ ] **Oyun Motoru (Context):** `Game.Engine` modülünü yazacağım. Bu modül şu işleri yapacak:
    *   Ülke yaratma.
    *   Kaynağı güvenli şekilde güncelleme (Transaction ile).

### 3. Arayüz ve Canlı Bağlantı (Frontend - LiveView)
*   [ ] **Layout Tasarımı:** `root.html.heex` dosyasını Tailwind CSS ile karanlık mod (Dark Mode) olacak şekilde temizleyeceğim.
*   [ ] **LiveView Modülü:** `CountryLive` adında bir süreç oluşturacağım.
    *   `mount`: Sayfa açılınca veriyi çeken fonksiyon.
    *   `render`: HTML'i çizen fonksiyon.
    *   `handle_event`: Butona basılınca çalışan fonksiyon.

### 4. Test ve Teslim
*   [ ] Kodları yazdıktan sonra nasıl çalıştıracağını gösteren tek bir komut vereceğim.

---

## ⏳ Tahmini Süreler (Benim Çalışmam)

1.  **Altyapı Dosyaları (Docker vb.):** ~5 Dakika
2.  **Backend Mantığı (Elixir Kodları):** ~15 Dakika
3.  **Frontend Arayüzü (LiveView):** ~15 Dakika
4.  **Hata Kontrolleri:** ~5 Dakika

**Toplam:** ~40-45 dakika içinde kodları yazıp sana "Çalıştır" komutunu vermeye hazır olurum.

---

*Not: Şu an kod yazımına başlanmadı. Sadece plan yapıldı ve dosyalar düzenlendi.*