# 🧪 Diplomasi Simülasyonu - Elixir & Phoenix LiveView MVP Planı

**Karar Verilen Mimari:**
*   **Dil:** Elixir (Erlang VM üzerinde) - *Yüksek hata toleransı ve eşzamanlılık için.*
*   **Web Framework:** Phoenix 1.7.3+
*   **Frontend/Etkileşim:** Phoenix LiveView - *Sunucu taraflı SPA deneyimi.*
*   **Stil:** Tailwind CSS v4 - *Modern UI tasarımı.*
*   **Veritabanı:** PostgreSQL via Ecto.
*   **Gerçek Zamanlı İletişim:** Phoenix PubSub.

---

## 🎯 MVP (Minimum Çalışan Ürün) Durumu: TAMAMLANDI ✅
**Gerçekleşen Kapsam:**
1.  **Ülke Seçimi (Lobby):** Kullanıcılar ülke kurabilir veya mevcut ülkelerle oyuna girebilir.
2.  **Ekonomi:** Vergi toplama (+Altın, -Moral) ve Pasif Gelir sistemi.
3.  **Askeri:** Ordu kurma ve diğer ülkelere Savaş İlan Etme (İşlem bazlı güvenli sistem).
4.  **Moral Sistemi:** Halkın mutluluğu vergi ve savaşla düşer, zamanla iyileşir.
5.  **Görsel Efektler:** Rolling numbers (Slot makinesi etkisi) ve saldırı anında ekran titremesi.
6.  **Real-Time:** Tüm güncellemeler PubSub üzerinden tüm istemcilere anlık yansır.
7.  **Deployment:** VPS/Ubuntu için Docker + Nginx yapılandırması hazırlandı.

---

## 🤖 Gemini'nin (Agent) Görev Listesi

### 1. Hazırlık ve Altyapı ✅
*   [x] **Docker Compose Hazırlığı:** `docker-compose.yml` ve `Dockerfile` oluşturuldu.
*   [x] **Phoenix Projesi Oluşturma:** İskelet yapı kuruldu.

### 2. Veritabanı ve Mantık (Backend) ✅
*   [x] **Migration:** `countries` tablosuna `budget`, `army_count` ve `happiness` eklendi.
*   [x] **Schema Tanımı:** `Country` modeli validasyonlarla kuruldu.
*   [x] **Oyun Motoru (Context):** `Diplomacy.Game` modülü Transaction desteğiyle yazıldı.
*   [x] **OTP İşlemleri:** `Game.Ticker` ile her 5 saniyede bir kaynak/moral güncellemesi.

### 3. Arayüz ve Canlı Bağlantı (Frontend - LiveView) ✅
*   [x] **Lobby (HomeLive):** Gerçek zamanlı ülke listesi ve oluşturma formu.
*   [x] **Dashboard (CountryLive):** Komuta merkezi arayüzü.
*   [x] **JS Hooks:** Sayıların dönme efekti (`RollingNumber`) ve ekran sarsma.
*   [x] **Responsive:** Mobil cihazlar için tam uyumlu grid sistemi.

### 4. Test ve Teslim ✅
*   [x] **Unit & Integration Test:** 13/13 test başarıyla geçiyor.
*   [x] **Production Config:** VPS kurulumu için `deploy/` klasörü oluşturuldu.

---

## 🚀 Gelecek Planları (V2)
1.  **Diplomasi:** Ülkeler arası ittifak veya ticaret teklifleri.
2.  **İstihbarat:** Diğer ülkelerin tam bütçesini görme (şu an herkes görüyor, gizlenebilir).
3.  **Harita:** Basit bir 2D harita üzerinde konumlandırma.
4.  **Kalıcı Kullanıcı:** Auth sistemi (şimdilik ID bazlı).

---

*Durum: MVP başarıyla tamamlandı ve Git deposuna hazır hale getirildi.*
