# JARKOM MODUL 5 2026 - K61

## Member

| Nama               | NRP        |
| ------------------ | ---------- |
| Ferlin Erdina Sari | 5027251002 |
| Achmad Rifqy Aqila | 5027251102 |

---

### 1. Penjelasan Konsep & Metode

- ## TOPOLOGI

Topologi jaringanmemisahkan fungsi gerbang perbatasan (_edge gateway_), distribusi antar-cabang, dan lapisan akses pengguna (_access layer_). Seluruh infrastruktur internal beroperasi di bawah satu blok jaringan induk **RFC 1918 `10.94.0.0/21`** ($2.048$ alamat IP) dan terhubung ke jaringan eksternal/internet melalui perangkat cloud **`NAT1`** (`192.168.122.0/24`).

Secara keseluruhan, topologi ini terdiri atas **17 router** berbasis Linux (`debinet`) dan **25 node klien/server** yang tersebar ke dalam **17 segmen LAN** serta dihubungkan oleh **16 tautan _Point-to-Point_ (`/30`)**.

![Topologi Jaringan Geofront](assets/Soal01_02_Topologi_Jaringan_Geofront.png)

- ## VLSM

  **File Excel Tabel VLSM:** [K61_TABEL_VLSM.xlsx](assets/K61_TABEL_VLSM.xlsx)

Pada tahap perancangan pengalamatan IP, jaringan Geofront menggunakan blok jaringan induk **`10.94.0.0/21`** yang memiliki total kapasitas $2^{(32 - 21)} = 2.048$ alamat IP (`10.94.0.0` – `10.94.7.255`). Apabila digunakan pembagian subnet berukuran tetap (_Fixed-Length Subnet Mask_ / FLSM), akan terjadi pemborosan alamat yang sangat besar karena kebutuhan tiap segmen jaringan sangat bervariasi—mulai dari segmen klien besar seperti _Quarters_ hingga link _Point-to-Point_ antar-router yang hanya membutuhkan 2 alamat host valid.

Oleh karena itu, digunakan metode **_Variable Length Subnet Mask_** **(VLSM)** dengan prinsip mengurutkan kebutuhan host dari **kapasitas terbesar ke kapasitas terkecil** (_descending_). Pendekatan ini menjamin alokasi blok IP selalu jatuh pada batas kelipatan ukuran bloknya (_subnet boundary_), mencegah terjadinya tumpang tindih (_overlapping_) antar-subnet, serta menghasilkan efisiensi pemakaian IP sebesar **58,40%** ($1.196$ dari $2.048$ alamat terpakai) dengan sisa ruang yang masih memadai untuk ekspansi jaringan di masa mendatang.

### 2. Perhitungan VLSM

1. **Blok `/23` (512 alamat — 510 host valid):**
   - Rumus ukuran blok: $2^{(32 - 23)} = 2^9 = 512$ alamat (`Subnet Mask: 255.255.254.0`).
   - Digunakan untuk **Switch-Quarters** (`10.94.0.0/23`).
2. **Blok `/24` (256 alamat — 254 host valid):**
   - Rumus ukuran blok: $2^{(32 - 24)} = 2^8 = 256$ alamat (`Subnet Mask: 255.255.255.0`).
   - Digunakan untuk **Switch-Comm** (`10.94.2.0/24`).
3. **Blok `/25` (128 alamat — 126 host valid):**
   - Rumus ukuran blok: $2^{(32 - 25)} = 2^7 = 128$ alamat (`Subnet Mask: 255.255.255.128`).
   - Digunakan untuk **Switch-Hangar** (`10.94.3.0/25`).
4. **Blok `/26` (64 alamat — 62 host valid):**
   - Rumus ukuran blok: $2^{(32 - 26)} = 2^6 = 64$ alamat (`Subnet Mask: 255.255.255.192`).
   - Digunakan untuk **Switch-Bunker** (`10.94.3.128/26`).
5. **Blok `/27` (32 alamat — 30 host valid):**
   - Rumus ukuran blok: $2^{(32 - 27)} = 2^5 = 32$ alamat (`Subnet Mask: 255.255.255.224`).
   - Digunakan untuk 3 subnet: **Switch-Medic** (`10.94.3.192/27`), **Switch-Relay** (`10.94.3.224/27`), dan **Switch-Garden** (`10.94.4.0/27`).
6. **Blok `/28` (16 alamat — 14 host valid):**
   - Rumus ukuran blok: $2^{(32 - 28)} = 2^4 = 16$ alamat (`Subnet Mask: 255.255.255.240`).
   - Digunakan untuk **Switch-Dock** (`10.94.4.32/28`).
7. **Blok `/29` (8 alamat — 6 host valid):**
   - Rumus ukuran blok: $2^{(32 - 29)} = 2^3 = 8$ alamat (`Subnet Mask: 255.255.255.248`).
   - Digunakan untuk 6 subnet: **Switch-Lab** (`10.94.4.48/29`), **Switch-Radar** (`10.94.4.56/29`), **Switch-Terminal** (`10.94.4.64/29`), **Switch-Cage** (`10.94.4.72/29`), **Switch-Dogma** (`10.94.4.80/29`), dan **Switch-Monolith** (`10.94.4.88/29`).
8. **Blok `/30` (4 alamat — 2 host valid):**
   - Rumus ukuran blok: $2^{(32 - 30)} = 2^2 = 4$ alamat (`Subnet Mask: 255.255.255.252`).
   - Digunakan untuk 3 LAN kecil (**Switch-Archive**, **Switch-Intel**, **Switch-Cmd**) serta **16 link Point-to-Point** antar-router (`L1` hingga `L16`).

### 3. Tabel Alokasi 33 Subnet VLSM

| No  | Subnet / LAN              | Ukuran Blok | Prefix | Network ID    | Subnet Mask       | Rentang Host Valid            | Broadcast     | Gateway (IP Router) |
| :-- | :------------------------ | :---------: | :----: | :------------ | :---------------- | :---------------------------- | :------------ | :------------------ |
| 1   | Switch-Quarters           |     512     | `/23`  | `10.94.0.0`   | `255.255.254.0`   | `10.94.0.2` – `10.94.1.254`   | `10.94.1.255` | `10.94.0.1`         |
| 2   | Switch-Comm               |     256     | `/24`  | `10.94.2.0`   | `255.255.255.0`   | `10.94.2.2` – `10.94.2.254`   | `10.94.2.255` | `10.94.2.1`         |
| 3   | Switch-Hangar             |     128     | `/25`  | `10.94.3.0`   | `255.255.255.128` | `10.94.3.2` – `10.94.3.126`   | `10.94.3.127` | `10.94.3.1`         |
| 4   | Switch-Bunker             |     64      | `/26`  | `10.94.3.128` | `255.255.255.192` | `10.94.3.130` – `10.94.3.190` | `10.94.3.191` | `10.94.3.129`       |
| 5   | Switch-Medic              |     32      | `/27`  | `10.94.3.192` | `255.255.255.224` | `10.94.3.194` – `10.94.3.222` | `10.94.3.223` | `10.94.3.193`       |
| 6   | Switch-Relay              |     32      | `/27`  | `10.94.3.224` | `255.255.255.224` | `10.94.3.226` – `10.94.3.254` | `10.94.3.255` | `10.94.3.225`       |
| 7   | Switch-Garden             |     32      | `/27`  | `10.94.4.0`   | `255.255.255.224` | `10.94.4.2` – `10.94.4.30`    | `10.94.4.31`  | `10.94.4.1`         |
| 8   | Switch-Dock               |     16      | `/28`  | `10.94.4.32`  | `255.255.255.240` | `10.94.4.34` – `10.94.4.46`   | `10.94.4.47`  | `10.94.4.33`        |
| 9   | Switch-Lab                |      8      | `/29`  | `10.94.4.48`  | `255.255.255.248` | `10.94.4.50` – `10.94.4.54`   | `10.94.4.55`  | `10.94.4.49`        |
| 10  | Switch-Radar              |      8      | `/29`  | `10.94.4.56`  | `255.255.255.248` | `10.94.4.58` – `10.94.4.62`   | `10.94.4.63`  | `10.94.4.57`        |
| 11  | Switch-Terminal           |      8      | `/29`  | `10.94.4.64`  | `255.255.255.248` | `10.94.4.66` – `10.94.4.70`   | `10.94.4.71`  | `10.94.4.65`        |
| 12  | Switch-Cage               |      8      | `/29`  | `10.94.4.72`  | `255.255.255.248` | `10.94.4.74` – `10.94.4.78`   | `10.94.4.79`  | `10.94.4.73`        |
| 13  | Switch-Dogma              |      8      | `/29`  | `10.94.4.80`  | `255.255.255.248` | `10.94.4.82` – `10.94.4.86`   | `10.94.4.87`  | `10.94.4.81`        |
| 14  | Switch-Monolith           |      8      | `/29`  | `10.94.4.88`  | `255.255.255.248` | `10.94.4.90` – `10.94.4.94`   | `10.94.4.95`  | `10.94.4.89`        |
| 15  | Switch-Archive            |      4      | `/30`  | `10.94.4.96`  | `255.255.255.252` | `10.94.4.98` – `10.94.4.98`   | `10.94.4.99`  | `10.94.4.97`        |
| 16  | Switch-Intel              |      4      | `/30`  | `10.94.4.100` | `255.255.255.252` | `10.94.4.102` – `10.94.4.102` | `10.94.4.103` | `10.94.4.101`       |
| 17  | Switch-Cmd                |      4      | `/30`  | `10.94.4.104` | `255.255.255.252` | `10.94.4.106` – `10.94.4.106` | `10.94.4.107` | `10.94.4.105`       |
| 18  | L1 (`GENDOU – FUYUTSUKI`) |      4      | `/30`  | `10.94.4.108` | `255.255.255.252` | `10.94.4.109` – `10.94.4.110` | `10.94.4.111` | `-`                 |
| 19  | L2 (`GENDOU – SHIGERU`)   |      4      | `/30`  | `10.94.4.112` | `255.255.255.252` | `10.94.4.113` – `10.94.4.114` | `10.94.4.115` | `-`                 |
| 20  | L3 (`GENDOU – MISATO`)    |      4      | `/30`  | `10.94.4.116` | `255.255.255.252` | `10.94.4.117` – `10.94.4.118` | `10.94.4.119` | `-`                 |
| 21  | L4 (`GENDOU – KAJI`)      |      4      | `/30`  | `10.94.4.120` | `255.255.255.252` | `10.94.4.121` – `10.94.4.122` | `10.94.4.123` | `-`                 |
| 22  | L5 (`GENDOU – ASUKA`)     |      4      | `/30`  | `10.94.4.124` | `255.255.255.252` | `10.94.4.125` – `10.94.4.126` | `10.94.4.127` | `-`                 |
| 23  | L6 (`GENDOU – HIKARI`)    |      4      | `/30`  | `10.94.4.128` | `255.255.255.252` | `10.94.4.129` – `10.94.4.130` | `10.94.4.131` | `-`                 |
| 24  | L7 (`GENDOU – YUI`)       |      4      | `/30`  | `10.94.4.132` | `255.255.255.252` | `10.94.4.133` – `10.94.4.134` | `10.94.4.135` | `-`                 |
| 25  | L8 (`FUYUTSUKI – MAYA`)   |      4      | `/30`  | `10.94.4.136` | `255.255.255.252` | `10.94.4.137` – `10.94.4.138` | `10.94.4.139` | `-`                 |
| 26  | L9 (`FUYUTSUKI – TOJI`)   |      4      | `/30`  | `10.94.4.140` | `255.255.255.252` | `10.94.4.141` – `10.94.4.142` | `10.94.4.143` | `-`                 |
| 27  | L10 (`SHIGERU – MAKOTO`)  |      4      | `/30`  | `10.94.4.144` | `255.255.255.252` | `10.94.4.145` – `10.94.4.146` | `10.94.4.147` | `-`                 |
| 28  | L11 (`ASUKA – KENSUKE`)   |      4      | `/30`  | `10.94.4.148` | `255.255.255.252` | `10.94.4.149` – `10.94.4.150` | `10.94.4.151` | `-`                 |
| 29  | L12 (`ASUKA – RITSUKO`)   |      4      | `/30`  | `10.94.4.152` | `255.255.255.252` | `10.94.4.153` – `10.94.4.154` | `10.94.4.155` | `-`                 |
| 30  | L13 (`HIKARI – KAWORU`)   |      4      | `/30`  | `10.94.4.156` | `255.255.255.252` | `10.94.4.157` – `10.94.4.158` | `10.94.4.159` | `-`                 |
| 31  | L14 (`YUI – MARI`)        |      4      | `/30`  | `10.94.4.160` | `255.255.255.252` | `10.94.4.161` – `10.94.4.162` | `10.94.4.163` | `-`                 |
| 32  | L15 (`YUI – REI`)         |      4      | `/30`  | `10.94.4.164` | `255.255.255.252` | `10.94.4.165` – `10.94.4.166` | `10.94.4.167` | `-`                 |
| 33  | L16 (`YUI – SHINJI`)      |      4      | `/30`  | `10.94.4.168` | `255.255.255.252` | `10.94.4.169` – `10.94.4.170` | `10.94.4.171` | `-`                 |

### 4. Pengujian & Dokumentasi

1. **Verifikasi Konsistensi Alokasi Subnet (Pengecekan Overlap & Kapasitas):**
   ```bash
   # Memastikan seluruh subnet berada di dalam blok induk 10.94.0.0/21 (10.94.0.0 - 10.94.7.255)
   ipcalc 10.94.0.0/21
   ```

- **Bukti Dokumentasi:**
  ![Tabel Alokasi VLSM Geofront](dokumentasi/Soal01_01_Tabel_VLSM_Lengkap.png)

---

## Soal 2: Konfigurasi IP Interface & IP Forwarding pada 17 Router

### 1. Penjelasan Konsep

Pada tahap ini dilakukan penetapan alamat IP statis (_static IP addressing_) pada seluruh antarmuka jaringan fisik di 17 router Geofront sesuai hasil pemetaan VLSM. Setiap router memiliki dua peran antarmuka:

- **Antarmuka _Uplink/Downlink_ (`/30`):** Menghubungkan router secara langsung (_Point-to-Point_) dengan router induk maupun router cabang di bawahnya.
- **Antarmuka LAN (Gateway):** Menggunakan alamat IP host valid pertama pada setiap segmen switch klien sebagai gerbang keluar (_default gateway_) bagi perangkat di bawahnya.

Selain konfigurasi alamat IP dan pengaktifan status tautan (`ip link set dev <iface> up`), parameter kernel Linux **`net.ipv4.ip_forward=1`** wajib diaktifkan pada seluruh 17 router agar sistem operasi berperan sebagai _IP router_ yang meneruskan paket data antar-antarmuka, bukan menjatuhkannya.

### 2. Skrip Konfigurasi IP Interface & IP Forwarding

- **Router `Gendou`:**

  ```bash
  ip addr flush dev eth0; ip addr add 192.168.122.10/24 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.105/30 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.133/30 dev eth2; ip link set eth2 up
  ip addr flush dev eth3; ip addr add 10.94.4.129/30 dev eth3; ip link set eth3 up
  ip addr flush dev eth4; ip addr add 10.94.4.125/30 dev eth4; ip link set eth4 up
  ip addr flush dev eth5; ip addr add 10.94.4.121/30 dev eth5; ip link set eth5 up
  ip addr flush dev eth6; ip addr add 10.94.4.117/30 dev eth6; ip link set eth6 up
  ip addr flush dev eth7; ip addr add 10.94.4.113/30 dev eth7; ip link set eth7 up
  ip addr flush dev eth8; ip addr add 10.94.4.109/30 dev eth8; ip link set eth8 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Fuyutsuki`, `Maya`, dan `Toji`:**

  ```bash
  # Fuyutsuki
  ip addr flush dev eth0; ip addr add 10.94.4.110/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.65/29 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.137/30 dev eth2; ip link set eth2 up
  ip addr flush dev eth3; ip addr add 10.94.4.141/30 dev eth3; ip link set eth3 up
  sysctl -w net.ipv4.ip_forward=1

  # Maya
  ip addr flush dev eth0; ip addr add 10.94.4.138/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.3.193/27 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1

  # Toji
  ip addr flush dev eth0; ip addr add 10.94.4.142/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.81/29 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Shigeru` dan `Makoto`:**

  ```bash
  # Shigeru
  ip addr flush dev eth0; ip addr add 10.94.4.114/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.89/29 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.145/30 dev eth2; ip link set eth2 up
  sysctl -w net.ipv4.ip_forward=1

  # Makoto
  ip addr flush dev eth0; ip addr add 10.94.4.146/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.57/29 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Misato` dan `Kaji`:**

  ```bash
  # Misato
  ip addr flush dev eth0; ip addr add 10.94.4.118/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.73/29 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1

  # Kaji
  ip addr flush dev eth0; ip addr add 10.94.4.122/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.101/30 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Asuka`, `Kensuke`, dan `Ritsuko`:**

  ```bash
  # Asuka
  ip addr flush dev eth0; ip addr add 10.94.4.126/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.97/30 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.149/30 dev eth2; ip link set eth2 up
  ip addr flush dev eth3; ip addr add 10.94.4.153/30 dev eth3; ip link set eth3 up
  sysctl -w net.ipv4.ip_forward=1

  # Kensuke
  ip addr flush dev eth0; ip addr add 10.94.4.150/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.49/29 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1

  # Ritsuko
  ip addr flush dev eth0; ip addr add 10.94.4.154/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.33/28 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Hikari` dan `Kaworu`:**

  ```bash
  # Hikari
  ip addr flush dev eth0; ip addr add 10.94.4.130/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.1/27 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.157/30 dev eth2; ip link set eth2 up
  sysctl -w net.ipv4.ip_forward=1

  # Kaworu
  ip addr flush dev eth0; ip addr add 10.94.4.158/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.3.225/27 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

- **Router `Yui`, `Mari`, `Rei`, dan `Shinji`:**

  ```bash
  # Yui
  ip addr flush dev eth0; ip addr add 10.94.4.134/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.3.129/26 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.161/30 dev eth2; ip link set eth2 up
  ip addr flush dev eth3; ip addr add 10.94.4.165/30 dev eth3; ip link set eth3 up
  ip addr flush dev eth4; ip addr add 10.94.4.169/30 dev eth4; ip link set eth4 up
  sysctl -w net.ipv4.ip_forward=1

  # Mari
  ip addr flush dev eth0; ip addr add 10.94.4.162/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.3.1/25 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1

  # Rei
  ip addr flush dev eth0; ip addr add 10.94.4.166/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.2.1/24 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1

  # Shinji
  ip addr flush dev eth0; ip addr add 10.94.4.170/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.0.1/23 dev eth1; ip link set eth1 up
  sysctl -w net.ipv4.ip_forward=1
  ```

### 3. Pengujian & Analisis Hasil

1. **Verifikasi Status Antarmuka & Parameter Kernel IP Forwarding:**
   ```bash
   ip -br a
   sysctl net.ipv4.ip_forward
   ```
   _Hasil:_ Seluruh antarmuka (`eth0` s.d. `eth8`) berstatus `UP` dengan IP/prefix yang tepat, dan parameter `net.ipv4.ip_forward = 1` aktif.
2. **Uji Konektivitas Langsung (_Direct Link_ `/30`) Antar-Router Bertetangga:**
   ```bash
   ping -c 3 10.94.4.110   # Uji link L1 Gendou -> Fuyutsuki
   ping -c 3 10.94.4.114   # Uji link L2 Gendou -> Shigeru
   ping -c 3 10.94.4.118   # Uji link L3 Gendou -> Misato
   ping -c 3 10.94.4.122   # Uji link L4 Gendou -> Kaji
   ```
   _Hasil:_ Seluruh link _Point-to-Point_ (`/30`) merespons dengan `0% packet loss`.

### DOKUMENTASI

![Konfigurasi IP Router Gendou](assets/Soal02_01_Router_Gendou_IP_Config.png)
![Konfigurasi IP Router Yui](assets/Soal02_02_Router_Yui_IP_Config.png)
![Konfigurasi IP Router Hikari](assets/Soal02_03_Router_Hikari_IP_Config.png)
![Konfigurasi IP Router Asuka](assets/Soal02_04_Router_Asuka_IP_Config.png)
![Konfigurasi IP Router Shigeru](assets/Soal02_05_Router_Shigeru_IP_Config.png)
![Konfigurasi IP Router Fuyutsuki](assets/Soal02_06_Router_Fuyutsuki_IP_Config.png)
![Konfigurasi IP Router Mari](assets/Soal02_07_Router_Mari_IP_Config.png)
![Konfigurasi IP Router Rei](assets/Soal02_08_Router_Rei_IP_Config.png)
![Konfigurasi IP Router Shinji](assets/Soal02_09_Router_Shinji_IP_Config.png)
![Konfigurasi IP Router Kaworu](assets/Soal02_10_Router_Kaworu_IP_Config.png)
![Konfigurasi IP Router Kensuke](assets/Soal02_11_Router_Kensuke_IP_Config.png)
![Konfigurasi IP Router Ritsuko](assets/Soal02_12_Router_Ritsuko_IP_Config.png)
![Konfigurasi IP Router Kaji](assets/Soal02_13_Router_Kaji_IP_Config.png)
![Konfigurasi IP Router Misato](assets/Soal02_14_Router_Misato_IP_Config.png)
![Konfigurasi IP Router Makoto](assets/Soal02_15_Router_Makoto_IP_Config.png)
![Konfigurasi IP Router Maya](assets/Soal02_16_Router_Maya_IP_Config.png)
![Konfigurasi IP Router Toji](assets/Soal02_17_Router_Toji_IP_Config.png)

---

## Soal 3: Konfigurasi Static Routing Antar-Cabang (17 Router)

### 1. Penjelasan Konsep

Setelah seluruh antarmuka memiliki IP, setiap router secara bawaan hanya mengetahui jaringan yang terhubung langsung (_directly connected_). Agar paket dapat berpindah lintas cabang (misalnya dari segmen `Switch-Dogma` di bawah `Toji` menuju segmen `Switch-Monolith` di bawah `Shigeru`), dikonfigurasi **_Static Routing_** berbasis arsitektur pohon (_tree topology_):

- **Arah Naik (_Upstream_):** Seluruh router akses dan distribusi memiliki `default route` (`0.0.0.0/0`) menuju router induknya di atas hingga bermuara ke **`Gendou`**.
- **Arah Turun (_Downstream_):** Router pusat **`Gendou`** dan router distribusi menengah (`Fuyutsuki`, `Shigeru`, `Asuka`, `Hikari`, `Yui`) memiliki entri rute statis spesifik menuju subnet cabang di bawahnya agar paket balasan dapat diarahkan secara presisi tanpa terjadi _routing loop_.

### 2. Skrip Konfigurasi Static Routing

- **Router Pusat `Gendou`:**

  ```bash
  ip route replace default via 192.168.122.1 dev eth0
  # Cabang Fuyutsuki (eth8 -> 10.94.4.110)
  ip route replace 10.94.4.64/29 via 10.94.4.110 dev eth8
  ip route replace 10.94.4.136/29 via 10.94.4.110 dev eth8
  ip route replace 10.94.3.192/27 via 10.94.4.110 dev eth8
  ip route replace 10.94.4.80/29 via 10.94.4.110 dev eth8
  # Cabang Shigeru (eth7 -> 10.94.4.114)
  ip route replace 10.94.4.88/29 via 10.94.4.114 dev eth7
  ip route replace 10.94.4.144/30 via 10.94.4.114 dev eth7
  ip route replace 10.94.4.56/29 via 10.94.4.114 dev eth7
  # Cabang Misato & Kaji (eth6 -> 10.94.4.118, eth5 -> 10.94.4.122)
  ip route replace 10.94.4.72/29 via 10.94.4.118 dev eth6
  ip route replace 10.94.4.100/30 via 10.94.4.122 dev eth5
  # Cabang Asuka (eth4 -> 10.94.4.126)
  ip route replace 10.94.4.96/30 via 10.94.4.126 dev eth4
  ip route replace 10.94.4.148/29 via 10.94.4.126 dev eth4
  ip route replace 10.94.4.48/29 via 10.94.4.126 dev eth4
  ip route replace 10.94.4.32/28 via 10.94.4.126 dev eth4
  # Cabang Hikari (eth3 -> 10.94.4.130)
  ip route replace 10.94.4.0/27 via 10.94.4.130 dev eth3
  ip route replace 10.94.4.156/30 via 10.94.4.130 dev eth3
  ip route replace 10.94.3.224/27 via 10.94.4.130 dev eth3
  # Cabang Yui (eth2 -> 10.94.4.134)
  ip route replace 10.94.3.128/26 via 10.94.4.134 dev eth2
  ip route replace 10.94.4.160/28 via 10.94.4.134 dev eth2
  ip route replace 10.94.3.0/25 via 10.94.4.134 dev eth2
  ip route replace 10.94.2.0/24 via 10.94.4.134 dev eth2
  ip route replace 10.94.0.0/23 via 10.94.4.134 dev eth2
  ```

- **Router Distribusi (`Fuyutsuki`, `Shigeru`, `Asuka`, `Hikari`, `Yui`):**

  ```bash
  # Fuyutsuki
  ip route replace default via 10.94.4.109
  ip route replace 10.94.3.192/27 via 10.94.4.138 dev eth2
  ip route replace 10.94.4.80/29 via 10.94.4.142 dev eth3

  # Shigeru
  ip route replace default via 10.94.4.113
  ip route replace 10.94.4.56/29 via 10.94.4.146 dev eth2

  # Asuka
  ip route replace default via 10.94.4.125
  ip route replace 10.94.4.48/29 via 10.94.4.150 dev eth2
  ip route replace 10.94.4.32/28 via 10.94.4.154 dev eth3

  # Hikari
  ip route replace default via 10.94.4.129
  ip route replace 10.94.3.224/27 via 10.94.4.158 dev eth2

  # Yui
  ip route replace default via 10.94.4.133
  ip route replace 10.94.3.0/25 via 10.94.4.162 dev eth2
  ip route replace 10.94.2.0/24 via 10.94.4.166 dev eth3
  ip route replace 10.94.0.0/23 via 10.94.4.170 dev eth4
  ```

- **Router Akses (Leaf Routers):**
  ```bash
  # Maya, Toji, Makoto, Misato, Kaji, Kensuke, Ritsuko, Kaworu, Mari, Rei, Shinji
  ip route replace default via <IP_Uplink_Router_Induk>
  ```

### 3. Pengujian & Analisis Hasil

1. **Inspeksi Tabel Routing (`ip route`) pada `Gendou` & Router Distribusi:**
   ```bash
   ip route
   ```
   _Hasil:_ Seluruh rute statis menuju subnet cabang terdaftar tanpa konflik dan mengarah ke antarmuka _next-hop_ yang benar.
2. **Uji Konektivitas Multi-Hop Lintas Cabang (`Lilith` ke `Armisael`):**
   ```bash
   traceroute -n 10.94.4.91
   ping -c 3 10.94.4.91
   ```
   _Hasil:_ Paket melewati 6 hop (`Lilith` $\rightarrow$ `Toji` $\rightarrow$ `Fuyutsuki` $\rightarrow$ `Gendou` $\rightarrow$ `Shigeru` $\rightarrow$ `Armisael`) dengan `0% packet loss`.

### DOKUMENTASI

![Tabel Routing dan Ping Awal di Gendou](assets/Soal03_01_Gendou_Routing_Table_dan_Ping_1.png)
![Uji Ping Tier 1 Selesai di Gendou](assets/Soal03_02_Gendou_Ping_Tier1_Selesai.png)
![Tabel Routing dan Uji Ping Hikari](assets/Soal03_03_Hikari_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Asuka](assets/Soal03_04_Asuka_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Shigeru](assets/Soal03_05_Shigeru_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Fuyutsuki](assets/Soal03_06_Fuyutsuki_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Mari](assets/Soal03_07_Mari_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Rei](assets/Soal03_08_Rei_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Shinji](assets/Soal03_09_Shinji_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Kaworu](assets/Soal03_10_Kaworu_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Kensuke](assets/Soal03_11_Kensuke_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Shigeru (Lanjutan)](assets/Soal03_12_Shigeru_Route_dan_Ping_2.png)
![Tabel Routing dan Uji Ping Ritsuko](assets/Soal03_13_Ritsuko_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Kaji](assets/Soal03_14_Kaji_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Misato](assets/Soal03_15_Misato_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Makoto](assets/Soal03_16_Makoto_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Maya](assets/Soal03_17_Maya_Route_dan_Ping.png)
![Tabel Routing dan Uji Ping Toji](assets/Soal03_18_Toji_Route_dan_Ping.png)
![Traceroute Jalur Dummy-Plug ke Armisael](assets/Soal03_19_DummyPlug_Traceroute_ke_Armisael.png)

---

## Soal 4: Konfigurasi NAT Masquerade (`Gendou`)

### 1. Penjelasan Konsep

Seluruh perangkat di dalam jaringan Geofront menggunakan alamat IP privat RFC 1918 (`10.94.0.0/21`) yang tidak dapat dirutekan secara langsung di internet publik. Untuk memungkinkan klien internal mengakses layanan luar (seperti repositori Debian dan DNS publik `8.8.8.8`), diterapkan **_Source Network Address Translation_ (`MASQUERADE`)** pada rantai `POSTROUTING` di router perbatasan **`Gendou`**.

Mekanisme `MASQUERADE` mencegat setiap paket keluar yang bersumber dari `10.94.0.0/21` melalui antarmuka WAN `eth0`, mengganti alamat IP sumber privatnya dengan alamat IP antarmuka keluar `Gendou` (`192.168.122.10`), serta mencatat pemetaan port tersebut pada tabel _connection tracking_ (`conntrack`) agar paket balasan dari internet dapat diterjemahkan kembali ke klien pengirim aslinya.

### 2. Skrip Konfigurasi NAT Masquerade (`Gendou`)

```bash
iptables -t nat -F
iptables -t nat -A POSTROUTING -s 10.94.0.0/21 -o eth0 -j MASQUERADE
```

### 3. Pengujian & Analisis Hasil

1. **Verifikasi Aturan NAT pada Tabel `nat` di `Gendou`:**
   ```bash
   iptables -t nat -L -n -v
   ```
   _Hasil:_ Aturan `MASQUERADE` aktif pada rantai `POSTROUTING` dengan sumber `10.94.0.0/21` dan antarmuka keluar `eth0`.
2. **Pengujian Translasi Alamat dari Klien Internal menuju Internet (`8.8.8.8`):**
   ```bash
   ping -c 3 8.8.8.8
   ```
   _Hasil:_ Klien internal menerima balasan dari `8.8.8.8` dengan `0% packet loss`, membuktikan translasi SNAT/Masquerade berjalan dua arah.

### DOKUMENTASI

![Konfigurasi NAT1 DHCP dan Ping Internet di Gendou](assets/Soal04_01_Gendou_NAT1_DHCP_Ping_Internet.png)
![Uji Ping LAN dan Internet](assets/Soal04_02_DummyPlug_Uji_Ping_LAN_dan_Internet.png)

---

## Soal 5: Konfigurasi Stateful Firewall (`Gendou`)

### 1. Penjelasan Konsep

Sebagai satu-satunya gerbang perbatasan antara jaringan internal Geofront (`10.94.0.0/21`) dengan jaringan eksternal (`NAT1`), **`Gendou`** diamankan menggunakan `iptables` berbasis **Stateful Packet Inspection** dengan kebijakan bawaan ketat (_Default Deny_):

- **Kebijakan `INPUT DROP` & `FORWARD DROP`:** Menolak secara otomatis segala bentuk lalu lintas yang mencoba masuk ke router maupun melintas antar-jaringan tanpa izin eksplisit.
- **Pelacakan Status Koneksi (`--ctstate ESTABLISHED,RELATED`):** Mengizinkan paket balasan dari luar masuk kembali hanya apabila paket tersebut merupakan bagian dari sesi koneksi sah yang terlebih dahulu diinisiasi oleh klien internal Geofront.
- **Pembatasan Sumber Internal (`-s 10.94.0.0/21`):** Memastikan hanya paket yang berasal dari blok jaringan Geofront yang diizinkan keluar ke internet maupun berkomunikasi antar-subnet.

### 2. Skrip Konfigurasi Firewall (`Gendou`)

```bash
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Aturan rantai INPUT (Akses lokal router)
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -i eth0 -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -s 10.94.0.0/21 -j ACCEPT

# Aturan rantai FORWARD (Lalu lintas transit klien)
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s 10.94.0.0/21 -o eth0 -j ACCEPT
iptables -A FORWARD -s 10.94.0.0/21 -d 10.94.0.0/21 -j ACCEPT
```

### 3. Pengujian & Analisis Hasil

1. **Inspeksi Kebijakan & Aturan Filter Firewall di `Gendou`:**
   ```bash
   iptables -L -n -v
   ```
   _Hasil:_ Kebijakan default `INPUT` dan `FORWARD` tercatat `DROP`, dengan penghitung paket (`pkts`) meningkat pada aturan `ESTABLISHED,RELATED` dan `-s 10.94.0.0/21`.
2. **Uji Lalu Lintas Transit Sah vs. Blokir Lalu Lintas Tidak Sah:**
   ```bash
   # Dari klien internal (10.94.0.0/21) menuju internet -> DIIZINKAN
   ping -c 3 8.8.8.8
   ```
   _Hasil:_ Koneksi yang diinisiasi klien internal lolos melewati rantai `FORWARD`, sementara paket asing yang tidak memiliki status `ESTABLISHED` dari luar ditolak oleh kebijakan `DROP`.

### DOKUMENTASI

![Konfigurasi Iptables Policy DROP, NAT, dan Firewall di Gendou](assets/Soal05_01_Gendou_Iptables_NAT_dan_Firewall.png)

---

## Soal 6: Konfigurasi IP Permanen & DNS pada Seluruh 25 Klien

### 1. Penjelasan Konsep

Seluruh 25 perangkat klien dan server layanan dikonfigurasi menggunakan pengalamatan IP statis (_static IP_) di dalam berkas `/etc/network/interfaces` agar konfigurasi antarmuka tersimpan secara persisten dan dapat diaktifkan menggunakan perintah `ifup -a`. Setiap klien diberikan alamat IP host valid dari blok subnet VLSM masing-masing, _subnet mask_ yang sesuai, serta **`gateway`** yang merujuk pada alamat antarmuka LAN router terdekat. Selain itu, berkas `/etc/resolv.conf` diisi dengan `nameserver 8.8.8.8` agar seluruh node dapat melakukan resolusi nama domain (_DNS lookup_).

### 2. Skrip Konfigurasi `/etc/network/interfaces` Seluruh 25 Klien

#### A. Cabang `Fuyutsuki` (`Terminal`, `Medic`, `Dogma`)

1. **`Magi-Casper` (Switch-Terminal — `10.94.4.64/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.66
       netmask 255.255.255.248
       gateway 10.94.4.65
   ```
2. **`Magi-Balthasar` (Switch-Terminal — `10.94.4.64/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.67
       netmask 255.255.255.248
       gateway 10.94.4.65
   ```
3. **`Magi-Melchior` (Switch-Terminal — `10.94.4.64/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.68
       netmask 255.255.255.248
       gateway 10.94.4.65
   ```
4. **`Pen-Pen` (Switch-Medic via `Maya` — `10.94.3.192/27`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.3.194
       netmask 255.255.255.224
       gateway 10.94.3.193
   ```
5. **`Lilith` (Switch-Dogma via `Toji` — `10.94.4.80/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.82
       netmask 255.255.255.248
       gateway 10.94.4.81
   ```
6. **`Adam` (Switch-Dogma via `Toji` — `10.94.4.80/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.83
       netmask 255.255.255.248
       gateway 10.94.4.81
   ```

#### B. Cabang `Shigeru` (`Monolith`, `Radar`)

7. **`Seele-01` (Switch-Monolith — `10.94.4.88/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.90
       netmask 255.255.255.248
       gateway 10.94.4.89
   ```
8. **`Armisael` (Switch-Monolith — `10.94.4.88/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.91
       netmask 255.255.255.248
       gateway 10.94.4.89
   ```
9. **`Tabris` (Switch-Radar via `Makoto` — `10.94.4.56/29`):**
   ```ini
   auto eth0
   iface eth0 inet static
       address 10.94.4.58
       netmask 255.255.255.248
       gateway 10.94.4.57
   ```

#### C. Cabang `Misato`, `Kaji`, dan `Gendou` (`Cage`, `Intel`, `Cmd`)

10. **`Unit-01` (Switch-Cage via `Misato` — `10.94.4.72/29`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.74
        netmask 255.255.255.248
        gateway 10.94.4.73
    ```
11. **`Unit-02` (Switch-Cage via `Misato` — `10.94.4.72/29`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.75
        netmask 255.255.255.248
        gateway 10.94.4.73
    ```
12. **`Unit-00` (Switch-Cage via `Misato` — `10.94.4.72/29`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.76
        netmask 255.255.255.248
        gateway 10.94.4.73
    ```
13. **`Spy` (Switch-Intel via `Kaji` — `10.94.4.100/30`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.102
        netmask 255.255.255.252
        gateway 10.94.4.101
    ```
14. **`Tokyo3-Core` (Switch-Cmd via `Gendou` — `10.94.4.104/30`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.106
        netmask 255.255.255.252
        gateway 10.94.4.105
    ```

#### D. Cabang `Asuka` (`Archive`, `Lab`, `Dock`)

15. **`Dummy-Plug` (Switch-Archive — `10.94.4.96/30`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.98
        netmask 255.255.255.252
        gateway 10.94.4.97
    ```
16. **`Jet-Alone` (Switch-Lab via `Kensuke` — `10.94.4.48/29`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.50
        netmask 255.255.255.248
        gateway 10.94.4.49
    ```
17. **`Sachiel` (Switch-Dock via `Ritsuko` — `10.94.4.32/28`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.34
        netmask 255.255.255.240
        gateway 10.94.4.33
    ```
18. **`Shamshel` (Switch-Dock via `Ritsuko` — `10.94.4.32/28`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.35
        netmask 255.255.255.240
        gateway 10.94.4.33
    ```

#### E. Cabang `Hikari` (`Garden`, `Relay`)

19. **`Ramiel` (Switch-Garden — `10.94.4.0/27`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.4.2
        netmask 255.255.255.224
        gateway 10.94.4.1
    ```
20. **`Gaghiel` (Switch-Relay via `Kaworu` — `10.94.3.224/27`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.3.226
        netmask 255.255.255.224
        gateway 10.94.3.225
    ```
21. **`Israfel` (Switch-Relay via `Kaworu` — `10.94.3.224/27`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.3.227
        netmask 255.255.255.224
        gateway 10.94.3.225
    ```

#### F. Cabang `Yui` (`Bunker`, `Hangar`, `Comm`, `Quarters`)

22. **`Sandalphon` (Switch-Bunker — `10.94.3.128/26`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.3.130
        netmask 255.255.255.192
        gateway 10.94.3.129
    ```
23. **`Matarael` (Switch-Hangar via `Mari` — `10.94.3.0/25`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.3.2
        netmask 255.255.255.128
        gateway 10.94.3.1
    ```
24. **`Sahaquiel` (Switch-Comm via `Rei` — `10.94.2.0/24`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.2.2
        netmask 255.255.255.0
        gateway 10.94.2.1
    ```
25. **`Bardiel` (Switch-Quarters via `Shinji` — `10.94.0.0/23`):**
    ```ini
    auto eth0
    iface eth0 inet static
        address 10.94.0.2
        netmask 255.255.254.0
        gateway 10.94.0.1
    ```

#### G. Aktivasi Antarmuka & DNS pada Seluruh 25 Klien

```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ifup -a
```

### 3. Pengujian & Analisis Hasil

1. **Verifikasi Alamat IP, Gateway, & DNS pada Klien:**
   ```bash
   ip -br a
   ip route
   cat /etc/resolv.conf
   ```
   _Hasil:_ Seluruh 25 klien memiliki IP statis, _default gateway_, dan resolver DNS `8.8.8.8` yang aktif.
2. **Uji Konektivitas End-to-End & Resolusi Nama Domain dari Klien:**
   ```bash
   ping -c 3 10.94.0.2         # Uji antar-klien lintas cabang (Lilith -> Bardiel)
   ping -c 3 deb.debian.org    # Uji resolusi DNS & akses internet
   ```
   _Hasil:_ Komunikasi lintas ujung jaringan dan resolusi DNS berjalan dengan `0% packet loss`.

### DOKUMENTASI

![Konfigurasi IP Client Quarters](assets/Soal06_01_Client_Quarters_IP_Config.png)
![Konfigurasi IP Client HangarCrew](assets/Soal06_02_Client_HangarCrew_IP_Config.png)
![Konfigurasi IP Client GardenStaff](assets/Soal06_03_Client_GardenStaff_IP_Config.png)
![Konfigurasi IP Server CommNet](assets/Soal06_04_Server_CommNet_IP_Config.png)
![Konfigurasi IP Client DockCrew](assets/Soal06_05_Client_DockCrew_IP_Config.png)
![Konfigurasi IP Server RelayNode](assets/Soal06_06_Server_RelayNode_IP_Config.png)
![Konfigurasi IP Client Sachiel](assets/Soal06_07_Client_Sachiel_IP_Config.png)
![Konfigurasi IP Client EntryPlug](assets/Soal06_08_Client_EntryPlug_IP_Config.png)
![Konfigurasi IP Client DummyPlug](assets/Soal06_09_Client_DummyPlug_IP_Config.png)
![Konfigurasi IP Server ArchiveVault](assets/Soal06_10_Server_ArchiveVault_IP_Config.png)
![Konfigurasi IP Server Tokyo3Core](assets/Soal06_11_Server_Tokyo3Core_IP_Config.png)
![Konfigurasi IP Client Spy](assets/Soal06_12_Client_Spy_IP_Config.png)
![Konfigurasi IP Client Unit-01 & Ping Gateway](assets/Soal06_13_Client_Unit01_IP_Config.png)
![Konfigurasi IP Client Unit-02](assets/Soal06_14_Client_Unit02_IP_Config.png)
![Konfigurasi IP Client Unit-00](assets/Soal06_15_Client_Unit00_IP_Config.png)
![Konfigurasi IP Client Zeruel](assets/Soal06_16_Client_Zeruel_IP_Config.png)
![Konfigurasi IP Client Armisael](assets/Soal06_17_Client_Armisael_IP_Config.png)
![Konfigurasi IP Server RadarArray](assets/Soal06_18_Server_RadarArray_IP_Config.png)
![Konfigurasi IP Server MagiCasper](assets/Soal06_19_Server_MagiCasper_IP_Config.png)
![Konfigurasi IP Server MagiBalthasar](assets/Soal06_20_Server_MagiBalthasar_IP_Config.png)
![Konfigurasi IP Server MagiMelchior](assets/Soal06_21_Server_MagiMelchior_IP_Config.png)
![Konfigurasi IP Server PenPen](assets/Soal06_22_Server_PenPen_IP_Config.png)
![Konfigurasi IP Client MedicBay](assets/Soal06_23_Client_MedicBay_IP_Config.png)
![Konfigurasi IP Client Lilith](assets/Soal06_24_Client_Lilith_IP_Config.png)
![Konfigurasi IP Client Adam](assets/Soal06_25_Client_Adam_IP_Config.png)

---

## Soal 7: Membangunkan Sistem MAGI (`Casper`, `Balthasar`, dan `Melchior`)

### 1. Penjelasan Konsep & Kendala Teknis

Ketiga superkomputer MAGI (`Magi-Casper` `10.94.4.66`, `Magi-Balthasar` `10.94.4.67`, dan `Magi-Melchior` `10.94.4.68`) berada pada subnet **Switch-Terminal (`10.94.4.64/29`)** di bawah router `Fuyutsuki`. Untuk mensimulasikan layanan komunikasi berbasis soket TCP, masing-masing node menjalankan proses _listener_ persisten (`nc.traditional -l -k -p <port>`) di latar belakang menggunakan `nohup` pada port `5000` (`Casper`), `5001` (`Balthasar`), dan `5002` (`Melchior`). Flag `-k` (_keep-listening_) digunakan agar _listener_ tetap aktif menerima koneksi berikutnya setelah klien pertama selesai mengirim pesan.

**Analisis Kendala Sinkronisasi Waktu (`APT OpenPGP Error`):**
Saat menjalankan `apt-get update`, muncul galat _signature verification_ (`Not live until 2026-11-23...`) karena jam sistem internal di dalam container GNS3 tertinggal di belakang waktu rilis sertifikat GPG repositori Debian Trixie. Masalah ini diselesaikan dengan menyetel waktu sistem menggunakan `date -s` dan menambahkan opsi `-o Acquire::Check-Valid-Until=false` sebelum menginstal `netcat-traditional`.

### 2. Skrip Konfigurasi Layanan MAGI

- **Di `Magi-Casper` (`10.94.4.66` — `/root/casper.sh`):**

  ```bash
  #!/bin/sh
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated iptables netcat-traditional
  pkill -f "nc.traditional" 2>/dev/null || true
  nohup nc.traditional -l -k -p 5000 > /tmp/casper.log 2>&1 &
  ```

- **Di `Magi-Balthasar` (`10.94.4.67` — `/root/balthasar.sh`):**

  ```bash
  #!/bin/sh
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated iptables netcat-traditional
  pkill -f "nc.traditional" 2>/dev/null || true
  nohup nc.traditional -l -k -p 5001 > /tmp/balthasar.log 2>&1 &
  ```

- **Di `Magi-Melchior` (`10.94.4.68` — `/root/melchior.sh`):**
  ```bash
  #!/bin/sh
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
  date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated iptables netcat-traditional
  pkill -f "nc.traditional" 2>/dev/null || true
  nohup nc.traditional -l -k -p 5002 > /tmp/melchior.log 2>&1 &
  ```

### 3. Pengujian & Dokumentasi

1. **Instalasi `netcat-traditional` & Pengiriman Pesan TCP dari `Lilith` (`10.94.4.82`) ke Ketiga Node MAGI:**
   ```bash
   date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
   apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated netcat-traditional
   echo "Halo Casper dari Lilith" | nc.traditional -w 1 10.94.4.66 5000
   echo "Halo Balthasar port 5001 dari Lilith" | nc.traditional -w 1 10.94.4.67 5001
   echo "Halo Melchior dari Lilith" | nc.traditional -w 1 10.94.4.68 5002
   ```
2. **Verifikasi Log Pesan Diterima di `Magi-Casper`, `Magi-Balthasar`, dan `Magi-Melchior`:**
   ```bash
   # Di Magi-Casper:
   cat /tmp/casper.log
   # Di Magi-Balthasar:
   cat /tmp/balthasar.log
   # Di Magi-Melchior:
   cat /tmp/melchior.log
   ```

### DOKUMENTASI

![Instalasi dan Status Listener OK di Casper](assets/Soal07_01_Casper_Install_Listener_OK.png)
![Instalasi dan Status Listener OK di Balthasar](assets/Soal07_02_Balthasar_Install_Listener_OK.png)
![Instalasi dan Status Listener OK di Melchior](assets/Soal07_03_Melchior_Install_Listener_OK.png)
![Pengiriman Pesan dari Lilith ke MAGI](assets/Soal07_04_Lilith_Kirim_Pesan_MAGI.png)
![Log Pesan Diterima di Casper](assets/Soal07_05_Casper_Log_Pesan_Diterima.png)
![Log Pesan Diterima di Balthasar](assets/Soal07_06_Balthasar_Log_Pesan_Diterima.png)
![Log Pesan Diterima di Melchior](assets/Soal07_07_Melchior_Log_Pesan_Diterima.png)

---

## Soal 8: Mengenali Kondisi Normal Layanan (`Pen-Pen` & `Tokyo3-Core`)

### 1. Penjelasan Konsep & Perilaku Port TCP

Sebelum melakukan simulasi gangguan, dilakukan pemetaan perilaku layanan normal pada dua server utama di jaringan Geofront, yaitu **`Pen-Pen`** (`10.94.3.194` di subnet _Medic_) dan **`Tokyo3-Core`** (`10.94.4.106` di subnet _Cmd_). Keduanya dikonfigurasi menjalankan _banner service_ menggunakan _loop_ `netcat-traditional` yang mengirimkan pesan identifikasi setiap kali menerima koneksi TCP masuk:

- **`Pen-Pen` (Port `80`):** Mengembalikan banner `Welcome to Pen-Pen`.
- **`Tokyo3-Core` (Port `80` & `8080`):** Mengembalikan banner `Welcome to Tokyo3-Core` pada port `80` dan `syifa imutz` pada port `8080`.

**Analisis Perbedaan Respons Port Terbuka vs. Port Tertutup:**
Ketika klien `Lilith` menguji port yang terbuka (`80` dan `8080`), proses _TCP 3-Way Handshake_ (`SYN` $\rightarrow$ `SYN-ACK` $\rightarrow$ `ACK`) berhasil diselesaikan dan server langsung mengirimkan data _payload_ banner. Sebaliknya, ketika `Lilith` memindai port **`22`** (`nc.traditional -zv -w 2 10.94.4.106 22`), status yang muncul adalah **`Connection refused`** secara seketika (tanpa menunggu _timeout_). Hal ini membuktikan bahwa jalur jaringan menuju `Tokyo3-Core` normal dan tidak diblokir secara diam-diam oleh firewall (`DROP`), melainkan tidak ada daemon SSH yang mendengarkan (_listening_) pada port `22` sehingga kernel membalas paket `SYN` dengan segmen TCP **`RST` (Reset)**.

### 2. Skrip Konfigurasi Layanan

- **Di `Pen-Pen` (`10.94.3.194` — `/root/penpen.sh`):**

  ```bash
  #!/bin/sh
  date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated netcat-traditional
  pkill -f "nc.traditional" 2>/dev/null || true
  while true; do printf "Welcome to Pen-Pen\n" | nc.traditional -l -p 80; done >/dev/null 2>&1 &
  ```

- **Di `Tokyo3-Core` (`10.94.4.106` — `/root/tokyo3.sh`):**
  ```bash
  #!/bin/sh
  date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true
  apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y --allow-unauthenticated netcat-traditional
  pkill -f "nc.traditional" 2>/dev/null || true
  while true; do printf "Welcome to Tokyo3-Core\n" | nc.traditional -l -p 80; done >/dev/null 2>&1 &
  while true; do printf "syifa imutz\n" | nc.traditional -l -p 8080; done >/dev/null 2>&1 &
  ```

### 3. Pengujian & Dokumentasi

1. **Verifikasi Aktivasi Listener di `Pen-Pen` dan `Tokyo3-Core`:**
   ```bash
   bash /root/penpen.sh
   bash /root/tokyo3.sh
   ```
2. **Pengujian Koneksi Port Terbuka (`80`, `8080`) dan Port Tertutup (`22`) dari `Lilith` (`10.94.4.82`):**
   ```bash
   echo "" | nc.traditional -w 2 10.94.3.194 80
   echo "" | nc.traditional -w 2 10.94.4.106 80
   echo "" | nc.traditional -w 2 10.94.4.106 8080
   nc.traditional -zv -w 2 10.94.4.106 22
   ```

### DOKUMENTASI

![Listener Port 80 di PenPen](assets/Soal08_01_PenPen_Listener_Port80.png)
![Listener Port 80 dan 8080 di Tokyo3Core](assets/Soal08_02_Tokyo3Core_Listener_Port80_8080.png)
![Uji Koneksi Netcat ke Port 80, 8080, dan 22 dari Lilith](assets/Soal08_03_Lilith_Uji_NC_Port80_8080_22.png)

---

## Soal 9: Sabotase Jalur Belakang (`Shigeru`)

### 1. Penjelasan Kasus & Diagnosis 4 Penyebab Kerusakan

Pada skenario ini, skrip sabotase `/root/break_routing.sh` dijalankan pada router **`Shigeru`**, yang mengakibatkan konektivitas antara cabang **Monolith** (`Armisael` — `10.94.4.91`) dengan seluruh cabang lain (seperti `Lilith` — `10.94.4.82`) terputus total (`100% packet loss`), meskipun `Armisael` tetap mampu melakukan _ping_ ke alamat gateway lokalnya (`10.94.4.89`).

Melalui inspeksi parameter kernel, tabel routing utama, serta aturan _Policy-Based Routing_ (`ip rule`), ditemukan **4 lapisan sabotase** yang ditanam secara bersamaan:

1. **Penonaktifan IP Forwarding (`net.ipv4.ip_forward = 0`):** Kernel `Shigeru` berhenti meneruskan paket antar-interface (`eth0` $\leftrightarrow$ `eth1`). `Armisael` tetap dapat mem-ping `10.94.4.89` karena komunikasi tersebut terjadi langsung di tingkat _data-link_ (Layer-2) dalam satu segmen switch tanpa memerlukan proses _routing_ lintas antarmuka.
2. **Pengalihan Default Route ke `Makoto` (`default via 10.94.4.146 dev eth2`):** Rute _default_ `Shigeru` yang seharusnya mengarah ke atas menuju router pusat **`Gendou`** (`10.94.4.113` via `eth0`) diganti sehingga mengarah ke bawah menuju router `Makoto`, menyebabkan trafik keluar cabang terjebak.
3. **Penyuntikan Rute `blackhole` (`blackhole 10.94.4.72/29`):** Skrip menambahkan rute _blackhole_ pada tabel routing utama yang membuang paket menuju jaringan tujuan secara diam-diam (_silent drop_) tanpa mengirimkan pesan kesalahan ICMP.
4. **Pembajakan dengan _Policy-Based Routing_ (`90: from all iif eth1 lookup 100`):** Skrip membuat aturan kebijakan routing baru pada prioritas `90` (lebih tinggi daripada tabel `main` pada prioritas `32766`) yang memaksa setiap paket masuk dari antarmuka LAN Monolith (`eth1`) untuk merujuk ke **tabel routing `100`**, di mana tabel `100` hanya berisi satu entri **`unreachable default`**.

### 2. Skrip Sabotase (`break_routing.sh`) & Perbaikan

- **Isi Skrip Sabotase (`/root/break_routing.sh`) di `Shigeru`:**

  ```bash
  #!/bin/sh
  if [ "$FORCE" != 1 ]; then case "$(hostname)" in *[Ss]higeru*) ;; *) echo "Script ini hanya untuk Shigeru."; exit 1;; esac; fi
  ip2int(){ _o=$IFS; IFS=.; set -- $1; IFS=$_o; echo $(( ($1<<24)+($2<<16)+($3<<8)+$4 )); }
  int2ip(){ echo "$(( ($1>>24)&255 )).$(( ($1>>16)&255 )).$(( ($1>>8)&255 )).$(( $1&255 ))"; }
  [ "$(id -u)" = 0 ] || { echo "Harus dijalankan sebagai root"; exit 1; }
  ADDRS=$(ip -4 -o addr show | while read _ dev fam addr _; do [ "$dev" = lo ] && continue; echo "$dev $addr"; done)
  DEFDEV=$(ip route show default | sed -n "s/.* dev \([^ ]*\).*/\1/p" | head -1)
  if ip rule show | grep -q "iif .* lookup 100"; then echo "Script sudah dijalankan sebelumnya"; exit 1; fi
  LANIF=; L30=; LANIP=
  while read dev addr; do
    [ -z "$dev" ] && continue
    if [ "${addr#*/}" = 30 ]; then L30="$L30 $dev:${addr%/*}"; else LANIF=$dev; LANIP=${addr%/*}; fi
  done <<EOT
  $ADDRS
  EOT
  UPIF=$DEFDEV; UPIP=; MKIF=; MKIP=
  for e in $L30; do d=${e%%:*}; i=${e#*:}; if [ "$d" = "$UPIF" ]; then UPIP=$i; else MKIF=$d; MKIP=$i; fi; done
  if [ -z "$LANIF" ] || [ -z "$UPIP" ] || [ -z "$MKIF" ]; then
    echo "Topologi Shigeru belum terdeteksi. Selesaikan soal 2 dan 3 dulu (IP semua interface dan default route ke Gendo)."; exit 1; fi
  MKGW=$(int2ip $(( $(ip2int $MKIP) ^ 3 )))
  P=${P:-${LANIP%.*.*}}
  DOGMA=${DOGMA:-$P.4.72/29}
  echo 0 > /proc/sys/net/ipv4/ip_forward
  ip route replace default via $MKGW dev $MKIF
  ip route del blackhole $DOGMA 2>/dev/null
  ip route add blackhole $DOGMA
  ip route flush table 100 2>/dev/null
  ip route add unreachable default table 100
  ip rule del iif $LANIF lookup 100 priority 90 2>/dev/null
  ip rule add iif $LANIF lookup 100 priority 90
  echo "Script sudah dirusak"
  ```

- **Perintah Pemulihan di `Shigeru`:**
  ```bash
  ip rule del priority 90 2>/dev/null || true
  ip route flush table 100 2>/dev/null || true
  ip route del blackhole 10.94.4.72/29 2>/dev/null || true
  ip route del blackhole 10.94.4.80/29 2>/dev/null || true
  bash /root/shigeru.sh
  ```

### 3. Pengujian & Dokumentasi

1. **Eksekusi Sabotase & Inspeksi 4 Penyebab Kerusakan di `Shigeru`:**
   ```bash
   bash /root/break_routing.sh
   sysctl net.ipv4.ip_forward
   ip route
   ip rule show
   ip route show table 100
   ```
2. **Uji Gejala dari `Lilith` Sebelum Perbaikan (`100% packet loss`):**
   ```bash
   ping -c 2 10.94.4.91
   ```
3. **Eksekusi Perbaikan di `Shigeru` & Verifikasi Ping Berhasil dari `Lilith` (`0% packet loss`):**

   ```bash
   # Di Shigeru:
   ip rule del priority 90 2>/dev/null || true
   ip route flush table 100 2>/dev/null || true
   ip route del blackhole 10.94.4.72/29 2>/dev/null || true
   ip route del blackhole 10.94.4.80/29 2>/dev/null || true
   bash /root/shigeru.sh

   # Di Lilith:
   ping -c 3 10.94.4.91
   ```

### DOKUMENTASI

![Eksekusi break_routing.sh di Shigeru](assets/Soal09_02_Shigeru_Eksekusi_break_routing.png)
![Inspeksi 4 Penyebab Sabotase di Shigeru](assets/Soal09_03_Shigeru_Inspeksi_4_Penyebab_Sabotase.png)
![Gejala Ping ke Armisael Gagal dari Lilith](assets/Soal09_04_Lilith_Gejala_Ping_Armisael_Gagal.png)
![Perbaikan Routing dan Rule Forward di Shigeru](assets/Soal09_05_Shigeru_Perbaikan_Routing_Rule_Forward.png)
![Verifikasi Ping ke Armisael Kembali Normal dari Lilith](assets/Soal09_06_Lilith_Verifikasi_Ping_Armisael_Normal.png)

---

## Soal 10: Para Pilot Terkunci di Dalam (`Misato` & `Gendou`)

### 1. Penjelasan Kasus & Analisis Teknis

Pada skenario terakhir, skrip sabotase `/root/break_nat.sh` dijalankan pada router **`Misato`** dan **`Gendou`**. Gejala yang muncul sangat spesifik: seluruh klien pilot di subnet **Cage** (`Unit-00`, `Unit-01`, `Unit-02` pada `10.94.4.72/29`) kehilangan akses menuju internet (`8.8.8.8`), tetapi komunikasi internal dari Cage menuju jaringan Geofront lain seperti **`Lilith`** (`10.94.4.82`) tetap berjalan lancar. Di sisi lain, klien pada cabang lain seperti **`Spy`** (`10.94.4.102` di subnet **Intel** `10.94.4.100/30` di bawah router `Kaji`) tetap dapat mengakses `8.8.8.8` secara normal.

**Hasil Investigasi & Jawaban Analisis:**

1. **SNAT Palsu (_Source NAT Poisoning_) di `Misato`:**
   `break_nat.sh` menambahkan aturan `iptables -t nat -A POSTROUTING -s 10.94.4.72/29 ! -d 10.94.0.0/16 -o eth0 -j SNAT --to-source 172.31.99.1` pada router `Misato`. Aturan ini mencegat setiap paket dari subnet Cage yang tujuannya berada di luar jaringan internal (`! -d 10.94.0.0/16`) dan memalsukan IP sumbernya menjadi alamat tidak valid **`172.31.99.1`**. Akibatnya, ketika paket tersebut mencapai `Gendou`, firewall `Gendou` (yang hanya mengizinkan sumber `10.94.0.0/21`) langsung membuang (`DROP`) paket tersebut.
2. **Pengecualian Translasi (`NAT Bypass` dengan Target `RETURN`) di `Gendou`:**
   `break_nat.sh` menyisipkan aturan `iptables -t nat -I POSTROUTING 1 -s 10.94.4.72/29 -o eth0 -j RETURN` pada urutan **pertama** rantai `POSTROUTING` di `Gendou`. Karena `iptables` mengevaluasi aturan dari atas ke bawah, paket dari Cage yang keluar lewat antarmuka internet (`eth0`) langsung keluar dari rantai `POSTROUTING` sebelum sempat diproses oleh aturan `MASQUERADE` di baris kedua. Paket dikirim ke `NAT1` tetap membawa IP privat `10.94.4.74` sehingga balasan dari internet tidak pernah dapat dirutekan kembali.
3. **Mengapa `Spy` (Intel) Tidak Terdampak & Ping ke `Lilith` Tetap Normal?**
   Kedua aturan sabotase di atas secara spesifik hanya memfilter alamat sumber `-s 10.94.4.72/29` (subnet Cage). Paket dari `Spy` (`10.94.4.102`) melewati aturan `RETURN` dan langsung diterjemahkan oleh `MASQUERADE`. Adapun ping dari `Unit-01` ke `Lilith` (`10.94.4.82`) tetap normal karena tujuan masih masuk dalam cakupan `10.94.0.0/16` (tidak memenuhi syarat `! -d 10.94.0.0/16` di `Misato`) dan tidak keluar melalui antarmuka WAN `eth0` di `Gendou`.
4. **Lokasi Translasi Alamat Sumber:**
   Penerjemahan alamat IP privat sumber menjadi alamat luar (`192.168.122.10`) dilakukan di router **`Gendou`** pada antarmuka **`eth0`** melalui mekanisme `MASQUERADE`, karena `Gendou` merupakan satu-satunya _edge gateway_ yang menghubungkan seluruh jaringan Geofront ke internet.

### 2. Skrip Sabotase (`break_nat.sh`) & Perbaikan

- **Isi Skrip Sabotase (`/root/break_nat.sh`) di `Misato` dan `Gendou`:**

  ```bash
  #!/bin/sh
  ip2int(){ _o=$IFS; IFS=.; set -- $1; IFS=$_o; echo $(( ($1<<24)+($2<<16)+($3<<8)+$4 )); }
  int2ip(){ echo "$(( ($1>>24)&255 )).$(( ($1>>16)&255 )).$(( ($1>>8)&255 )).$(( $1&255 ))"; }
  [ "$(id -u)" = 0 ] || { echo "Harus dijalankan sebagai root"; exit 1; }
  command -v iptables >/dev/null 2>&1 || { echo "iptables belum ada, mencoba memasang..."; (apt-get update -qq && apt-get install -y -qq iptables) >/dev/null 2>&1 || apk add -q iptables >/dev/null 2>&1; }
  command -v iptables >/dev/null 2>&1 || { echo "iptables gagal dipasang. Pasang manual dulu."; exit 1; }
  ADDRS=$(ip -4 -o addr show | while read _ dev fam addr _; do [ "$dev" = lo ] && continue; echo "$dev $addr"; done)
  DEFDEV=$(ip route show default | sed -n "s/.* dev \([^ ]*\).*/\1/p" | head -1)
  [ -n "$DEFDEV" ] || { echo "Default route belum ada. Selesaikan soal 2 sampai 4 dulu."; exit 1; }
  INTIP=$(echo "$ADDRS" | while read dev addr; do [ "$dev" != "$DEFDEV" ] && { echo "${addr%/*}"; break; }; done)
  P=${P:-${INTIP%.*.*}}
  case "$(hostname)" in
    *[Mm]isato*) NODE=misato ;;
    *[Gg]endo*) NODE=gendo ;;
    *) [ "$FORCE" = misato ] && NODE=misato; [ "$FORCE" = gendo ] && NODE=gendo
       [ -n "$NODE" ] || { echo "Jalankan di Misato dan di Gendo."; exit 1; } ;;
  esac
  if [ "$NODE" = misato ]; then
    CAGEIF=; while read dev addr; do [ "$dev" != "$DEFDEV" ] && { CAGEIF=$dev; CADDR=$addr; break; }; done <<EOT
  $ADDRS
  EOT
    [ -n "$CAGEIF" ] || { echo "Interface Cage tidak terdeteksi."; exit 1; }
    len=${CADDR#*/}; ipn=$(ip2int ${CADDR%/*}); mask=$(( (0xFFFFFFFF << (32-len)) & 0xFFFFFFFF ))
    CAGE=$(int2ip $(( ipn & mask )))/$len
    UPIF=$DEFDEV
  else
    WAN=$DEFDEV
    CAGE=${CAGE:-$P.4.64/29}
    ip route show | grep -q "^$CAGE " || echo "Subnet tidak terdeteksi"
  fi
  if [ "$NODE" = misato ]; then
    iptables -t nat -D POSTROUTING -s $CAGE ! -d $P.0.0/16 -o $UPIF -j SNAT --to-source 172.31.99.1 2>/dev/null
    iptables -t nat -A POSTROUTING -s $CAGE ! -d $P.0.0/16 -o $UPIF -j SNAT --to-source 172.31.99.1
  else
    iptables -t nat -D POSTROUTING -s $CAGE -o $WAN -j RETURN 2>/dev/null
    iptables -t nat -I POSTROUTING 1 -s $CAGE -o $WAN -j RETURN
  fi
  echo "Script sudah dirusak"
  ```

- **Perintah Pemulihan di `Misato` dan `Gendou`:**

  ```bash
  # Di Misato (membersihkan seluruh aturan SNAT palsu):
  iptables -t nat -F

  # Di Gendou (menghapus aturan RETURN pada posisi ke-1 POSTROUTING):
  iptables -t nat -D POSTROUTING 1
  ```

### 3. Pengujian & Dokumentasi

1. **Eksekusi Sabotase & Inspeksi Tabel NAT Rusak di `Misato` dan `Gendou`:**

   ```bash
   # Di Misato:
   bash /root/break_nat.sh
   iptables -t nat -L -n -v

   # Di Gendou:
   CAGE=10.94.4.72/29 bash /root/break_nat.sh
   iptables -t nat -L -n -v
   ```

2. **Uji Gejala dari `Unit-01` (`10.94.4.74`) dan `Spy` (`10.94.4.102`):**

   ```bash
   # Di Unit-01:
   ping -c 2 8.8.8.8
   ping -c 2 10.94.4.82

   # Di Spy:
   ping -c 2 8.8.8.8
   ```

3. **Eksekusi Perbaikan di `Misato` & `Gendou` serta Verifikasi Pemulihan dari `Unit-01`:**

   ```bash
   # Di Misato:
   iptables -t nat -F && iptables -t nat -L -n -v

   # Di Gendou:
   iptables -t nat -D POSTROUTING 1 && iptables -t nat -L -n -v

   # Di Unit-01:
   ping -c 3 8.8.8.8
   ```

### DOKUMENTASI

![Eksekusi break_nat.sh di Misato](assets/Soal10_02_Misato_Eksekusi_break_nat.png)
![Eksekusi break_nat.sh di Gendou](assets/Soal10_03_Gendou_Eksekusi_break_nat.png)
![Tabel NAT Rusak di Misato (SNAT Palsu)](assets/Soal10_04_Misato_Tabel_NAT_SNAT_Palsu.png)
![Tabel NAT Rusak di Gendou (Bypass RETURN)](assets/Soal10_05_Gendou_Tabel_NAT_Bypass_RETURN.png)
![Gejala Ping 8.8.8.8 Gagal & Lilith Sukses di Unit-01](assets/Soal10_06_Unit01_Gejala_Ping_8888_Gagal_Lilith_OK.png)
![Uji Ping 8.8.8.8 Normal di Spy](assets/Soal10_07_Spy_Ping_8888_Normal.png)
![Perbaikan Tabel NAT di Misato](assets/Soal10_08_Misato_Perbaikan_Flush_NAT.png)
![Perbaikan Tabel NAT di Gendou](assets/Soal10_09_Gendou_Perbaikan_Hapus_Rule_RETURN.png)
![Verifikasi Ping 8.8.8.8 Kembali Normal dari Unit-01](assets/Soal10_10_Unit01_Verifikasi_Ping_8888_Normal.png)



# Soal 11: Isolasi ICMP pada Magi-Casper ("Casper Harus Jadi Hantu")

## 1. Penjelasan Konsep

Pada tahap ini dilakukan pengamanan pada **Magi-Casper** (`10.94.4.66/29`) dengan menerapkan kebijakan *stateful firewall* menggunakan `iptables` pada rantai `INPUT`.

Tujuannya adalah menyembunyikan keberadaan Casper dari pemindaian ICMP (*ping*) perangkat lain, termasuk perangkat yang berada dalam satu segmen *broadcast* (`Switch-Terminal`: Magi-Balthasar `10.94.4.67` dan Magi-Melchior `10.94.4.68`), sambil tetap mempertahankan kemampuan Casper untuk menginisiasi ping keluar serta melayani koneksi aplikasi pada TCP port `5000`.

Mekanisme penyaringan bekerja berdasarkan urutan evaluasi aturan (*top-down*):

- **Loopback (`-i lo`)**: Diizinkan untuk menjaga komunikasi proses internal sistem operasi.
- **Stateful Inspection (`--ctstate ESTABLISHED,RELATED`)**: Diletakkan sebelum aturan pemblokiran ICMP agar paket balasan (`ICMP echo-reply`, tipe 0) dari sesi ping yang diinisiasi oleh Casper sendiri tetap dapat diterima.
- **Pemblokiran ICMP Masuk (`-p icmp --icmp-type echo-request -j DROP`)**: Menjatuhkan seluruh permintaan ping masuk (ICMP tipe 8) dari semua antarmuka jaringan tanpa mengirimkan pesan penolakan balik (*silent drop*).
- **Layanan MAGI (`-p tcp --dport 5000 -j ACCEPT`)**: Memastikan lalu lintas masuk menuju port layanan utama Casper tetap terbuka.

## 2. Skrip Konfigurasi Firewall (`Magi-Casper`)

Konfigurasi disimpan dan dieksekusi melalui berkas `/root/casper.sh`:

```bash
#!/bin/sh

# --- Inisialisasi Layanan MAGI ---
echo "nameserver 8.8.8.8" > /etc/resolv.conf
date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true

if ! dpkg -s iptables netcat-traditional >/dev/null 2>&1; then
    apt-get -o Acquire::Check-Valid-Until=false update
    apt-get install -y --allow-unauthenticated iptables netcat-traditional
fi

pkill -f "nc.traditional" 2>/dev/null || true
nohup nc.traditional -l -k -p 5000 > /tmp/casper.log 2>&1 &

# --- Aturan Firewall Soal 11 ---
iptables -F
iptables -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 1. Izinkan antarmuka loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. Izinkan balasan koneksi yang diinisiasi oleh Casper (termasuk echo-reply)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 3. Blokir seluruh ICMP echo-request masuk dari mana pun (termasuk satu switch)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 4. Izinkan koneksi masuk ke layanan TCP port 5000
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
```

## 3. Pengujian & Analisis Hasil

### 3.1 Verifikasi Daftar Aturan Firewall di `Magi-Casper`

Jalankan perintah berikut:

```bash
iptables -S
```

**Hasil:** Aturan `ESTABLISHED,RELATED` berada di atas aturan pemblokiran ICMP, yaitu `-p icmp -m icmp --icmp-type 8 -j DROP`. Aturan `-p tcp -m tcp --dport 5000 -j ACCEPT` juga aktif pada rantai `INPUT`.

### 3.2 Uji Ping Keluar dari `Magi-Casper` (`10.94.4.66`)

Uji koneksi ke Magi-Balthasar (`10.94.4.67`) dan Lilith (`10.94.4.82`):

```bash
ping -c 3 10.94.4.67
ping -c 3 10.94.4.82
```

**Hasil:** Kedua pengujian berhasil dengan **0% packet loss** (3 paket terkirim, 3 diterima). Paket `echo-reply` yang kembali dari Balthasar maupun Lilith dikenali oleh modul `conntrack` sebagai status `ESTABLISHED` sehingga lolos masuk ke Casper.

### 3.3 Uji Ping Masuk dari `Magi-Balthasar` dan `Lilith` ke `Magi-Casper`

Jalankan perintah berikut dari Magi-Balthasar (`10.94.4.67`) dan Lilith (`10.94.4.82`):

```bash
ping -c 3 10.94.4.66
```

**Hasil:** Kedua pengujian gagal dengan **100% packet loss** (3 paket terkirim, 0 diterima). Baik lalu lintas *Layer 2* dalam satu switch (`Switch-Terminal`) maupun lalu lintas *Layer 3* lintas router (`Switch-Dogma` → `Switch-Terminal`) diproses oleh kernel Magi-Casper dan dijatuhkan pada rantai `INPUT`.

## 4. Dokumentasi
1. Hasil perintah `iptables -S` di Magi-Casper.
   ![alt text](assets/image.png)
2. Hasil ping keluar dari Magi-Casper ke `10.94.4.67` dan `10.94.4.82`.
   ![alt text](assets/imagecopy.png)
3. Hasil ping masuk dari Magi-Balthasar ke `10.94.4.66` (**100% packet loss**).
   ![alt text](assets/image-1.png)
4. Hasil ping masuk dari Lilith ke `10.94.4.66` (**100% packet loss**).
   ![alt text](assets/image-2.png)


# Soal 12: Perbaikan Hardening Firewall pada Magi-Casper

## 1. Penjelasan Konsep

Pada tahap ini dilakukan diagnosis dan pemulihan konfigurasi firewall pada **Magi-Casper** (`10.94.4.66/29`) setelah eksekusi skrip sabotase `/root/break_fw.sh`.

Perbaikan dilakukan dengan tetap mempertahankan *policy* `INPUT DROP` dan penolakan paket ICMP masuk (*ping*) sesuai tujuan *hardening*, namun memulihkan alur lalu lintas yang sah:

- **Stateful Return Traffic (`--ctstate RELATED,ESTABLISHED` pada `INPUT`)**: Memungkinkan paket balasan dari koneksi yang diinisiasi oleh Casper sendiri, seperti balasan *echo-reply* saat `ping 8.8.8.8`, balasan kueri DNS, dan paket data `apt-get update`, lolos masuk meskipun kebijakan bawaan `INPUT` adalah `DROP`.
- **Akses DNS Keluar (`OUTPUT` tidak memblokir UDP/TCP port `53`)**: Memungkinkan Casper mengirimkan permintaan resolusi nama domain ke resolver DNS sehingga `apt-get update` dapat me-resolve alamat repositori (`deb.debian.org`).
- **Akses Layanan TCP Port `5000`**: Mengizinkan koneksi TCP masuk ke port `5000` tempat layanan `nc` milik Casper mendengarkan, sehingga klien sah seperti `Unit-00` dapat terhubung.

## 2. Temuan Penyebab & Analisis Gejala Setelah `break_fw.sh`

Hasil pemeriksaan `iptables -S` setelah menjalankan `/root/break_fw.sh` menunjukkan tiga penyebab utama:

1. **Hilangnya aturan `ESTABLISHED,RELATED` pada rantai `INPUT`**: Paket balasan dari `8.8.8.8` maupun server repositori `apt-get` tidak dikenali sebagai kelanjutan sesi keluar sehingga jatuh ke *policy* `-P INPUT DROP`. Akibatnya, `ping 8.8.8.8` mengalami `100% packet loss`.
2. **Aturan `-A OUTPUT -p udp -m udp --dport 53 -j DROP`**: Memblokir paket permintaan DNS keluar menuju port UDP `53`, sehingga memicu kegagalan resolusi nama domain (`Temporary failure resolving 'deb.debian.org'`) saat `apt-get update`.
3. **Hilangnya aturan `-A INPUT -p tcp -m tcp --dport 5000 -j ACCEPT`**: Seluruh koneksi baru ke TCP port `5000`, termasuk dari `Unit-00`, dijatuhkan oleh *policy* `INPUT DROP`.

Skrip perbaikan disimpan dan dijalankan melalui `/root/casper.sh`:

```bash
#!/bin/sh

echo "nameserver 8.8.8.8" > /etc/resolv.conf
date -s "2026-11-24 04:00:00" >/dev/null 2>&1 || true

if ! dpkg -s iptables netcat-traditional >/dev/null 2>&1; then
    apt-get -o Acquire::Check-Valid-Until=false update
    apt-get install -y --allow-unauthenticated iptables netcat-traditional
fi

pkill -f "nc.traditional.*5000" 2>/dev/null || true
nohup nc.traditional -l -k -p 5000 > /tmp/casper.log 2>&1 &

# --- Pemulihan Firewall Soal 12 ---
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. Izinkan balasan koneksi yang diinisiasi Casper
# (balasan ping, DNS, dan apt-get)
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 3. Tolak ping masuk (ICMP echo-request)
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 4. Izinkan koneksi masuk ke layanan TCP 5000
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT
```

## 3. Pengujian & Analisis Hasil

### 3.1 Verifikasi Rule Aktif di `Magi-Casper` (`10.94.4.66`)

Jalankan perintah berikut:

```bash
iptables -S
```

**Hasil:** *Policy* `-P INPUT DROP` tetap aktif bersama aturan `lo`, `RELATED,ESTABLISHED`, `-p icmp -m icmp --icmp-type 8 -j DROP`, dan `-p tcp -m tcp --dport 5000 -j ACCEPT`.

### 3.2 Uji Koneksi TCP Port `5000` dan Ping dari `Unit-00` ke `Magi-Casper`

Jalankan perintah berikut dari `Unit-00`:

```bash
nc -v -w 3 10.94.4.66 5000
ping -c 2 10.94.4.66
```

**Hasil:** Koneksi `nc` ke port `5000` berhasil (`Connection to 10.94.4.66 5000 port [tcp/*] succeeded!`), sedangkan `ping` ke `10.94.4.66` tetap gagal (`100% packet loss`) sesuai tujuan *hardening*.

### 3.3 Uji Ping `8.8.8.8` dan `apt-get update` di `Magi-Casper`

Jalankan perintah berikut di Magi-Casper:

```bash
ping -c 3 8.8.8.8
apt-get -o Acquire::Check-Valid-Until=false update
```

**Hasil:** `ping -c 3 8.8.8.8` berhasil dengan `0% packet loss`, dan `apt-get -o Acquire::Check-Valid-Until=false update` sukses (`Reading package lists... Done`).

## 4. Dokumentasi

1. Hasil perintah `iptables -S` di Magi-Casper.
   ![alt text](assets/image-3.png)
2. Hasil `nc -v -w 3 10.94.4.66 5000` dari Unit-00.
   ![alt text](assets/image-4.png)
3. Hasil `ping -c 2 10.94.4.66` dari Unit-00 (**100% packet loss**).
   ![alt text](assets/image-5.png)
4. Hasil `ping -c 3 8.8.8.8` di Magi-Casper (**0% packet loss**).
   ![alt text](assets/image-6.png)
5. Hasil `apt-get -o Acquire::Check-Valid-Until=false update` di Magi-Casper.
   ![alt text](assets/image-7.png)


# Soal 13: Pembatasan Akses Layanan TCP Port 5000 & 5001 pada Magi-Balthasar

## 1. Penjelasan Konsep

Pada tahap ini diterapkan kontrol akses berbasis alamat IP sumber (*source IP allowlisting*) pada **Magi-Balthasar** (`10.94.4.67/29`) untuk layanan TCP port `5000` dan `5001`.

Hanya **Magi-Casper** (`10.94.4.66`) serta perangkat **Pilot** yang diizinkan membuka koneksi ke kedua port tersebut, sedangkan perangkat lain, termasuk node dalam satu switch (`Magi-Melchior`) maupun lintas segmen (`Lilith` `10.94.4.82`), langsung ditolak.

Mekanisme penyaringan pada rantai `INPUT` menggunakan evaluasi berurutan:

- **Loopback (`-i lo`) & Stateful Return (`--ctstate ESTABLISHED,RELATED`)**: Menjaga komunikasi internal serta balasan koneksi keluar, seperti `ping 8.8.8.8` dan kueri DNS, tetap berjalan normal.
- **Allowlist IP Sumber (`-p tcp -s <IP> -m multiport --dports 5000,5001 -j ACCEPT`)**: Mengizinkan koneksi masuk ke port `5000` dan `5001` khusus dari alamat IP Casper dan para Pilot.
- **Penolakan Eksplisit (`-p tcp -m multiport --dports 5000,5001 -j REJECT --reject-with tcp-reset`)**: Menolak koneksi ke port `5000` dan `5001` dari alamat IP lain sekaligus mengirimkan paket `TCP RST` agar klien langsung mendapat balasan `Connection refused` tanpa menunggu *timeout*.

## 2. Skrip Konfigurasi Layanan & Firewall (`Magi-Balthasar`)

Konfigurasi layanan `nc` dan aturan `iptables` disimpan dan dieksekusi melalui `/root/balthasar.sh`:

```bash
#!/bin/sh

echo "nameserver 8.8.8.8" > /etc/resolv.conf

if ! command -v nc.traditional >/dev/null 2>&1; then
    apt-get -o Acquire::Check-Valid-Until=false update
    apt-get install -y --allow-unauthenticated iptables netcat-traditional
fi

NC_BIN=$(command -v nc.traditional || command -v nc)

pkill -f "nc.*-p 500[01]" 2>/dev/null || true

nohup "$NC_BIN" -l -k -p 5000 >/tmp/balthasar-5000.log 2>&1 </dev/null &
nohup "$NC_BIN" -l -k -p 5001 >/tmp/balthasar-5001.log 2>&1 </dev/null &

# --- Konfigurasi Firewall Soal 13 ---
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. Izinkan balasan koneksi yang sudah terbentuk
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# 3. Allowlist IP sumber untuk port 5000 dan 5001
for ip in 10.94.4.66 10.94.4.74 10.94.4.75 10.94.4.76 10.94.4.77 10.94.4.78 10.94.4.50; do
    iptables -A INPUT -p tcp -s "$ip" -m multiport --dports 5000,5001 -j ACCEPT
done

# 4. Tolak koneksi dari IP lain ke port 5000 dan 5001
iptables -A INPUT -p tcp -m multiport --dports 5000,5001 -j REJECT --reject-with tcp-reset
```

## 3. Pengujian & Analisis Hasil

### 3.1 Uji Akses dari `Unit-01` (`10.94.4.74`) ke `Magi-Balthasar` (`10.94.4.67`)

Jalankan perintah berikut dari Unit-01:

```bash
nc -v -w 3 10.94.4.67 5000
nc -v -w 3 10.94.4.67 5001
```

**Hasil:** Kedua koneksi berhasil (`Connection to 10.94.4.67 5000 port [tcp/*] succeeded!` dan `Connection to 10.94.4.67 5001 port [tcp/*] succeeded!`) karena alamat IP sumber tercantum dalam aturan `ACCEPT` sebelum aturan `REJECT`.

### 3.2 Uji Akses dari `Lilith` (`10.94.4.82`) ke `Magi-Balthasar` (`10.94.4.67`)

Jalankan perintah berikut dari Lilith:

```bash
nc -v -w 3 10.94.4.67 5000
nc -v -w 3 10.94.4.67 5001
```

**Hasil:** Kedua koneksi langsung ditolak (`Connection refused`) akibat cocok dengan aturan `REJECT --reject-with tcp-reset` pada port `5000` dan `5001`.

### 3.3 Uji Konektivitas Keluar (`ping 8.8.8.8`) dari `Magi-Balthasar`

Jalankan perintah berikut di Magi-Balthasar:

```bash
ping -c 2 8.8.8.8
```

**Hasil:** Berhasil dengan `0% packet loss`, membuktikan aturan `ESTABLISHED,RELATED` dan lalu lintas keluar tetap berjalan normal.

## 4. Dokumentasi

1. Hasil `nc` dari Unit-01 ke port `5000` dan `5001` (**koneksi berhasil**).
   ![alt text](assets/image-8.png)
2. Hasil `nc` dari Lilith ke port `5000` dan `5001` (**Connection refused**).
   ![alt text](assets/image-9.png)
3. Hasil `ping -c 2 8.8.8.8` di Magi-Balthasar (**0% packet loss**).
   ![alt text](assets/image-10.png)



# Soal 14: Pembatasan Akses Berbasis Waktu pada Pen-Pen

## 1. Penjelasan Konsep

Pada tahap ini diterapkan pembatasan akses berbasis waktu (*time-based access control*) pada **Pen-Pen** (`10.94.3.194/27`) menggunakan modul `iptables -m time` untuk lalu lintas **ICMP Echo Request (`ping`)** dan **TCP port `80`** tanpa mengubah jam sistem komputer.

Karena modul `-m time` di `iptables` mengevaluasi waktu berdasarkan **UTC** (`UTC = WIB - 7 jam`), jadwal kunjungan dikonversi sebagai berikut:

- **Pilot (`08:00`–`16:00` WIB, Senin–Jumat):** `01:00`–`09:00` UTC pada hari `Mon,Tue,Wed,Thu,Fri`.
- **Staf Geofront (`17:00`–`23:00` WIB, setiap hari):** `10:00`–`16:00` UTC setiap hari.
- **Terduga Dummy System (`Spy`):** Selalu ditolak tanpa memandang waktu.
- **Lainnya:** Tidak dibatasi.

Variabel jadwal (`PILOT_START`, `PILOT_STOP`, `PILOT_DAYS`, `STAF_START`, dan `STAF_STOP`) ditempatkan di bagian awal `/root/penpen.sh` agar mudah diubah saat pengujian dua kondisi waktu, kemudian dikembalikan ke jadwal aslinya.

## 2. Konfigurasi di `Pen-Pen` (`/root/penpen.sh`)

Bagian awal variabel jadwal menggunakan nilai jadwal asli soal, serta layanan listener TCP port `80` pada `/root/penpen.sh`:

```bash
#!/bin/sh

# --- Variabel Jadwal Akses ---
PILOT_START="01:00"
PILOT_STOP="09:00"
PILOT_DAYS="Mon,Tue,Wed,Thu,Fri"

STAF_START="10:00"
STAF_STOP="16:00"

# --- Layanan TCP Port 80 ---
pkill -f "nc.traditional" 2>/dev/null || true

while true; do
    printf "Welcome to Pen-Pen\n" | nc.traditional -l -p 80
done >/dev/null 2>&1 &
```

## 3. Pengujian & Analisis Hasil

### 3.1 Kondisi 1 — Jadwal Cocok dengan Jam Sekarang

Pengujian dilakukan pada rentang `14:00`–`16:00` UTC, hari `Wed`, ketika `date -u` menunjukkan waktu `14:59 UTC`.

- **Unit-01 (Pilot):** `ping` berhasil (`0% packet loss`) dan koneksi `nc` ke port `80` berhasil dengan balasan `Welcome to Pen-Pen`.
- **Lilith (Staf Geofront):** `ping` berhasil (`0% packet loss`) dan koneksi `nc` ke port `80` berhasil dengan balasan `Welcome to Pen-Pen`.
- **Spy (Terduga Dummy System):** `ping` gagal (`100% packet loss`) dan koneksi TCP port `80` tidak berhasil (`timed out` atau ditolak).

### 3.2 Kondisi 2 — Jadwal Tidak Cocok dengan Jam Sekarang

Pengujian dilakukan pada rentang `01:00`–`02:00` UTC.

- **Unit-01 (Pilot):** `ping` gagal (`100% packet loss`) dan koneksi TCP port `80` ditolak (`Connection refused`).
- **Lilith (Staf Geofront):** `ping` gagal (`100% packet loss`) dan koneksi TCP port `80` ditolak (`Connection refused`).
- **Spy (Terduga Dummy System):** `ping` gagal (`100% packet loss`) dan koneksi TCP port `80` tidak berhasil (`timed out` atau ditolak).

### 3.3 Pengembalian Konfigurasi

Setelah pengujian selesai, variabel di `/root/penpen.sh` dikembalikan ke nilai jadwal asli soal:

- Pilot: `01:00`–`09:00` UTC, hari `Mon,Tue,Wed,Thu,Fri`.
- Staf Geofront: `10:00`–`16:00` UTC, setiap hari.

Selanjutnya, skrip dijalankan ulang agar konfigurasi kembali menggunakan jadwal asli.

## 4. Dokumentasi

1. Hasil `ping` dan `nc` dari Unit-01 pada Kondisi 1.
   ![alt text](assets/image-11.png)
2. Hasil `ping` dan `nc` dari Lilith pada Kondisi 1.
   ![alt text](assets/image-15.png)
3. Hasil `ping` dan `nc` dari Spy pada Kondisi 1.
   ![alt text](assets/image-13.png)
4. Hasil `ping` dan `nc` dari Unit-01 pada Kondisi 2.
   ![alt text](assets/image-12.png)
5. Hasil `ping` dan `nc` dari Lilith pada Kondisi 2.
   ![alt text](assets/image-16.png)
6. Hasil `ping` dan `nc` dari Spy pada Kondisi 2.
   ![alt text](assets/image-14.png)
7. Bukti konfigurasi jadwal telah dikembalikan ke nilai asli.
   ![alt text](assets/image-17.png)


# Soal 15: Pembatasan Laju ICMP pada Tokyo3-Core

## 1. Penjelasan Konsep & Urutan Rule

Untuk melindungi **Tokyo3-Core** (`10.94.4.106`) dari banjir *ping*, pembatasan laju diterapkan pada rantai `INPUT` khusus paket **ICMP echo-request** (`icmptype 8`) menggunakan modul `-m limit --limit 5/second --limit-burst 5` dengan target `ACCEPT`, diikuti rule `DROP` untuk kelebihan paket `icmptype 8`.

Penempatan rule `ACCEPT` (`limit 5/sec`) dan `DROP` untuk `icmptype 8` **di atas** rule `ctstate RELATED,ESTABLISHED` memastikan paket *echo-request* beruntun tidak langsung diloloskan oleh pencocokan status `conntrack`, sehingga kelebihan *ping* masuk ke rule `DROP`.

Aturan ini tidak membatasi trafik di bawah batas maupun paket *ping* yang dikirim Tokyo3-Core sendiri. Paket keluar melalui rantai `OUTPUT`, sedangkan paket balasan masuk melalui rule `RELATED,ESTABLISHED`.

## 2. Konfigurasi di `Tokyo3-Core` (`/root/tokyo3-core.sh`)

```bash
#!/bin/sh

PING_LIMIT="5/second"
PING_BURST="5"

iptables -F INPUT
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 1. Izinkan loopback
iptables -A INPUT -i lo -j ACCEPT

# 2. Batasi ICMP echo-request masuk
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit "$PING_LIMIT" --limit-burst "$PING_BURST" -j ACCEPT

# 3. Drop ICMP echo-request yang melebihi batas
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

# 4. Izinkan balasan koneksi yang sudah terbentuk
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

## 3. Pengujian & Analisis Hasil

### 3.1 Ping Rapat dari `Lilith`

Jalankan perintah berikut dari Lilith:

```bash
ping -i 0.1 -c 50 10.94.4.106
```

**Hasil:** Sebanyak 30 dari 50 paket diterima dan 20 paket dibuang (**40% packet loss**). Hal ini disertai kenaikan *counter* baris ke-3 (`DROP icmp ... icmptype 8`) menjadi `20 pkts` (`1680 bytes`).

### 3.2 Ping Normal Berjeda dari `Lilith`

Jalankan perintah berikut dari Lilith:

```bash
ping -i 3 -c 4 10.94.4.106
```

**Hasil:** Seluruh 4 paket berhasil diterima (**0% packet loss**) karena laju pengiriman berada di bawah batas 5 paket/detik.

### 3.3 Ping Keluar dari `Tokyo3-Core`

Jalankan perintah berikut di Tokyo3-Core:

```bash
ping -c 3 -i 0.2 10.94.4.105
```

**Hasil:** Seluruh 3 paket berhasil (**0% packet loss**), membuktikan bahwa *ping* yang dikirim Tokyo3-Core sendiri tidak terhambat oleh aturan pembatasan ICMP masuk.

## 4. Dokumentasi

Tempelkan screenshot bukti pengujian pada bagian ini:

1. Hasil `ping -i 0.1 -c 50 10.94.4.106` dari Lilith.
   ![alt text](assets/image-18.png)
2. Hasil `ping -i 3 -c 4 10.94.4.106` dari Lilith.
   ![alt text](assets/image-19.png)
3. Hasil `iptables -L INPUT -v -n --line-numbers` di Tokyo3-Core.
   ![alt text](assets/image-20.png)
4. Hasil `ping -c 3 -i 0.2 10.94.4.105` dari Tokyo3-Core.
   ![alt text](assets/image-21.png)

## Soal 16: Deteksi dan Pemblokiran Percobaan Koneksi TCP pada Port Sensitif

### 1. Penjelasan Konsep

Pada tahap ini dilakukan penerapan mekanisme deteksi dan pemblokiran (*logging and filtering*) terhadap percobaan koneksi TCP yang mencurigakan dari perangkat **Dummy-Plug** (`10.94.4.51`) menuju port sensitif pada router **Tokyo3-Core** (`10.94.4.106`). Port yang menjadi target pembatasan adalah:

- **Port 22 (SSH):** Digunakan untuk layanan akses jarak jauh melalui protokol SSH.
- **Port 23 (Telnet):** Digunakan untuk layanan akses jarak jauh melalui protokol Telnet.
- **Port 3306 (MySQL):** Digunakan untuk layanan basis data MySQL.

Untuk mendeteksi dan menangani percobaan koneksi tersebut, digunakan dua rule utama pada rantai firewall `INPUT` menggunakan **iptables**:

1. **Rule LOG:** Mencatat setiap percobaan koneksi TCP dengan flag `SYN` dari alamat IP Dummy-Plug menuju port `22`, `23`, dan `3306`. Rule ini menggunakan parameter `--log-prefix "SCAN-NERV: "` sebagai penanda khusus pada log sistem sehingga aktivitas percobaan akses dapat diidentifikasi dan dihitung melalui *packet counter*.
2. **Rule REJECT:** Menolak koneksi yang berasal dari Dummy-Plug menuju ketiga port tersebut menggunakan parameter `--reject-with tcp-reset`. Mekanisme ini mengirimkan paket TCP RST kepada pengirim sehingga koneksi langsung ditolak dan menghasilkan pesan `Connection refused`.

Kedua rule ditempatkan secara berurutan setelah rule `RELATED,ESTABLISHED` agar paket koneksi yang sudah terbentuk tetap dapat diproses terlebih dahulu.

Sementara itu, layanan TCP pada port **80 (HTTP)** dan **8080 (HTTP alternatif)** tetap diaktifkan dan tidak termasuk dalam pembatasan. Dengan demikian, perangkat lain seperti **Lilith** tetap dapat mengakses layanan tersebut tanpa terkena aturan pemblokiran khusus Dummy-Plug.

### 2. Skrip Konfigurasi Firewall dan Deteksi Koneksi TCP

- **Router `Tokyo3-Core` (`/root/tokyo3-core.sh`):**

  ```bash
  #!/bin/sh

  DUMMY_IP="10.94.4.51"
  PING_LIMIT="5/second"
  PING_BURST="5"

  NC_BIN=$(command -v nc.traditional || command -v nc)

  pkill -f "nc.*-p 80" 2>/dev/null || true
  pkill -f "nc.*-p 8080" 2>/dev/null || true

  while true; do
      printf "Tokyo3-Core HTTP 80\n" | "$NC_BIN" -l -p 80
  done >/dev/null 2>&1 &

  while true; do
      printf "Tokyo3-Core HTTP 8080\n" | "$NC_BIN" -l -p 8080
  done >/dev/null 2>&1 &

  iptables -F INPUT
  iptables -P INPUT ACCEPT
  iptables -P FORWARD DROP
  iptables -P OUTPUT ACCEPT

  iptables -A INPUT -i lo -j ACCEPT

  iptables -A INPUT -p icmp --icmp-type echo-request \
      -m limit --limit "$PING_LIMIT" \
      --limit-burst "$PING_BURST" -j ACCEPT

  iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

  iptables -A INPUT -m conntrack \
      --ctstate ESTABLISHED,RELATED -j ACCEPT

  # Rule 1: Mencatat percobaan koneksi TCP mencurigakan
  iptables -A INPUT -s "$DUMMY_IP" -p tcp \
      -m multiport --dports 22,23,3306 --syn \
      -j LOG --log-prefix "SCAN-NERV: "

  # Rule 2: Menolak koneksi TCP dari Dummy-Plug
  iptables -A INPUT -s "$DUMMY_IP" -p tcp \
      -m multiport --dports 22,23,3306 \
      -j REJECT --reject-with tcp-reset
  ```

### 3. Pengujian & Analisis Hasil

1. **Pengujian Pemblokiran Port Sensitif dari Dummy-Plug:**

   ```bash
   nc -v -w 3 10.94.4.106 22
   nc -v -w 3 10.94.4.106 23
   nc -v -w 3 10.94.4.106 3306
   ```

   *Hasil:* Seluruh percobaan koneksi menuju port `22`, `23`, dan `3306` ditolak oleh firewall Tokyo3-Core dengan respons `Connection refused`. Hal ini membuktikan bahwa rule `REJECT` berhasil membatasi akses Dummy-Plug menuju port sensitif.

2. **Pengujian Layanan yang Tetap Diizinkan dari Dummy-Plug:**

   ```bash
   nc -v -w 3 10.94.4.106 80
   nc -v -w 3 10.94.4.106 8080
   ```

   *Hasil:* Koneksi menuju port `80` dan `8080` berhasil (`succeeded!`) dan menerima balasan layanan dari Tokyo3-Core. Hal ini membuktikan bahwa pembatasan firewall hanya berlaku pada port sensitif yang telah ditentukan.

3. **Verifikasi Packet Counter Rule LOG dan REJECT pada Tokyo3-Core:**

   ```bash
   iptables -L INPUT -v -n --line-numbers
   ```

   *Hasil:* Nilai *packet counter* dan *byte counter* pada rule `LOG` dengan prefix `SCAN-NERV: ` serta rule `REJECT` mengalami peningkatan sesuai jumlah percobaan koneksi dari Dummy-Plug. Hal ini menunjukkan bahwa aktivitas koneksi berhasil terdeteksi, dicatat, dan ditolak oleh firewall.

4. **Pengujian Akses dari Klien Lain (Lilith):**

   ```bash
   nc -v -w 3 10.94.4.106 80
   nc -v -w 3 10.94.4.106 8080
   ```

   *Hasil:* Perangkat Lilith tetap dapat terhubung ke layanan TCP port `80` dan `8080` pada Tokyo3-Core tanpa terkena pembatasan khusus Dummy-Plug. Hal ini membuktikan bahwa aturan firewall diterapkan secara spesifik berdasarkan alamat IP sumber dan port tujuan, sehingga tidak mengganggu konektivitas klien lainnya.

### DOKUMENTASI

1. hasil pengujian koneksi TCP ke port `22`, `23`, dan `3306` menggunakan perintah `nc -v -w 3 10.94.4.106 <port>` dengan hasil `Connection refused` dan hasil pengujian koneksi TCP ke port `80` dan `8080` yang berhasil (`succeeded!`) serta menerima balasan layanan dari Tokyo3-Core.
   ![alt text](assets/image-22.png)

2. hasil perintah `iptables -L INPUT -v -n --line-numbers` yang memperlihatkan urutan rule `LOG` dengan prefix `SCAN-NERV: ` dan `REJECT --reject-with tcp-reset`, beserta peningkatan *packet counter*.
   ![alt text](assets/image-23.png)

3. hasil pengujian koneksi TCP dari perangkat Lilith menuju port `80` dan `8080` pada Tokyo3-Core yang berhasil tanpa terkena pembatasan firewall.
   ![alt text](assets/image-24.png)

## Soal 17: Pengalihan Trafik TCP Menggunakan DNAT & MASQUERADE pada Router Fuyutsuki

### 1. Penjelasan Konsep

Pada tahap ini dilakukan penerapan mekanisme *Network Address Translation* (NAT) pada router **Fuyutsuki** untuk mengalihkan koneksi TCP dari perangkat **Magi-Casper** (`10.94.4.66`) yang ditujukan ke **Zeruel** (`10.94.4.90`) agar diteruskan ke perangkat **Pen-Pen** (`10.94.3.194`) secara transparan tanpa disadari oleh pengirim.

Mekanisme pengalihan trafik menggunakan dua aturan utama:

- **DNAT (Destination Network Address Translation):** Diterapkan pada rantai `PREROUTING` tabel `nat` untuk mengubah alamat IP tujuan paket TCP dari `10.94.4.90` (Zeruel) menjadi `10.94.3.194` (Pen-Pen) sebelum proses keputusan *routing*. Aturan ini hanya berlaku untuk protokol TCP sehingga trafik ICMP seperti `ping` tidak ikut dialihkan.
- **MASQUERADE (Source Network Address Translation):** Diterapkan pada rantai `POSTROUTING` tabel `nat` untuk mengubah alamat IP sumber paket TCP dari Magi-Casper menjadi alamat IP antarmuka keluar Fuyutsuki. Hal ini memastikan paket balasan dari Pen-Pen kembali melewati Fuyutsuki.

Dengan memanfaatkan mekanisme *connection tracking* (`conntrack`), alamat pada paket balasan secara otomatis diterjemahkan kembali sehingga Magi-Casper tetap menerima respons seolah-olah berkomunikasi langsung dengan Zeruel.

### 2. Skrip Konfigurasi NAT (DNAT & MASQUERADE)

- **Router `Fuyutsuki` (`/root/fuyutsuki.sh`):**

  ```bash
  #!/bin/sh

  CASPER_IP="10.94.4.66"
  ZERUEL_IP="10.94.4.90"
  PENPEN_IP="10.94.3.194"

  # Konfigurasi IP interface & routing Fuyutsuki
  ip addr flush dev eth0; ip addr add 10.94.4.110/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.65/29 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.137/30 dev eth2; ip link set eth2 up
  ip addr flush dev eth3; ip addr add 10.94.4.141/30 dev eth3; ip link set eth3 up

  sysctl -w net.ipv4.ip_forward=1 >/dev/null

  ip route replace default via 10.94.4.109
  ip route replace 10.94.3.192/27 via 10.94.4.138
  ip route replace 10.94.4.80/29 via 10.94.4.142

  # Membersihkan aturan NAT sebelumnya
  iptables -t nat -F PREROUTING
  iptables -t nat -F POSTROUTING

  iptables -P FORWARD ACCEPT

  # DNAT: Mengalihkan tujuan TCP Zeruel ke Pen-Pen
  iptables -t nat -A PREROUTING \
      -s "$CASPER_IP" -d "$ZERUEL_IP" -p tcp \
      -j DNAT --to-destination "$PENPEN_IP"

  # MASQUERADE: Mengubah alamat sumber paket TCP
  iptables -t nat -A POSTROUTING \
      -s "$CASPER_IP" -d "$PENPEN_IP" -p tcp \
      -j MASQUERADE
  ```

### 3. Pengujian & Analisis Hasil

1. **Pengujian Konektivitas ICMP dari Magi-Casper ke Zeruel:**

   ```bash
   ping -c 2 10.94.4.90
   ```

   *Hasil:* Seluruh paket ICMP berhasil diterima oleh Zeruel dengan `0% packet loss`. Hal ini membuktikan bahwa aturan DNAT hanya berlaku untuk protokol TCP sehingga trafik ICMP tidak ikut dialihkan ke Pen-Pen.

2. **Pengujian Pengiriman Pesan TCP dari Magi-Casper ke Zeruel:**

   ```bash
   printf "Pesan dari Casper ke Zeruel\n" | nc -w 3 10.94.4.90 9000
   ```

   *Hasil:* Meskipun koneksi ditujukan ke alamat IP Zeruel (`10.94.4.90`), pesan berhasil diteruskan melalui Fuyutsuki dan diterima oleh listener TCP port `9000` pada Pen-Pen (`10.94.3.194`). Hal ini membuktikan bahwa mekanisme DNAT berhasil mengubah alamat tujuan koneksi.

3. **Verifikasi Penerimaan Pesan pada Pen-Pen:**

   *Hasil:* Listener TCP port `9000` pada Pen-Pen menampilkan pesan `"Pesan dari Casper ke Zeruel"`. Hal ini menunjukkan bahwa paket TCP berhasil dialihkan ke perangkat tujuan yang sebenarnya, yaitu Pen-Pen.

4. **Verifikasi Listener pada Zeruel:**

   *Hasil:* Terminal listener TCP port `9000` pada Zeruel tetap kosong karena koneksi dari Magi-Casper telah dialihkan menuju Pen-Pen sebelum mencapai Zeruel.

5. **Verifikasi Tabel NAT pada Fuyutsuki:**

   ```bash
   iptables -t nat -L -v -n --line-numbers
   nft list table ip nat
   ```

   *Hasil:* Terlihat peningkatan *packet counter* pada aturan `PREROUTING` dengan target `DNAT` menuju `10.94.3.194` serta aturan `POSTROUTING` dengan target `MASQUERADE`. Hasil tersebut mengonfirmasi bahwa proses translasi alamat tujuan dan sumber berjalan sesuai skenario yang telah dikonfigurasi.

### DOKUMENTASI

1. Hasil pengujian ping dan pengiriman pesan TCP dari Magi-Casper ke Zeruel.
   ![alt text](assets/image-25.png)
2. Hasil penerimaan pesan TCP pada Pen-Pen.
   ![alt text](assets/image-26.png)
3. Hasil verifikasi listener TCP pada Zeruel yang tetap kosong.
   ![alt text](assets/image-27.png)
4. Hasil verifikasi aturan DNAT dan MASQUERADE pada Fuyutsuki.
   ![alt text](assets/image-28.png)


## Soal 18: Konfigurasi Firewall FORWARD untuk Melindungi Zona Monolith dan Radar pada Router Shigeru

### 1. Penjelasan Konsep

Pada tahap ini dilakukan penerapan aturan firewall menggunakan **iptables** pada rantai `FORWARD` di router **Shigeru** untuk melindungi zona Monolith dan Radar dari trafik yang berasal dari jaringan luar, yaitu jaringan yang terhubung melalui interface `eth0` dan menghadap ke router Gendo.

Terdapat tiga aturan utama yang diterapkan:

- **ESTABLISHED,RELATED:** Mengizinkan paket balasan dari koneksi yang telah terbentuk maupun koneksi terkait agar komunikasi yang dimulai dari dalam zona Monolith/Radar tetap berjalan normal.
- **Pengecualian ICMP Subnet Terminal:** Mengizinkan paket ICMP `echo-request` yang berasal dari subnet Terminal (`10.94.4.64/29`) dan masuk melalui interface `eth0`. Aturan ini memberikan pengecualian agar perangkat Magi-Casper tetap dapat melakukan pengujian konektivitas.
- **DROP Trafik dari eth0:** Menjatuhkan seluruh trafik lainnya yang masuk melalui interface `eth0` sehingga jaringan luar tidak dapat memulai koneksi baru menuju zona Monolith dan Radar.

Dengan urutan aturan tersebut, komunikasi balasan dari dalam zona tetap diizinkan, subnet Terminal mendapatkan pengecualian untuk melakukan ping, sedangkan trafik masuk lainnya dari jaringan luar akan diblokir.

### 2. Konfigurasi Firewall FORWARD pada Router Shigeru

- **Router `Shigeru`:**

  ```bash
  # Membersihkan aturan FORWARD sebelumnya
  iptables -F FORWARD

  # Mengizinkan koneksi yang sudah terbentuk dan terkait
  iptables -A FORWARD -m conntrack \
      --ctstate ESTABLISHED,RELATED -j ACCEPT

  # Mengizinkan ICMP dari subnet Terminal melalui eth0
  iptables -A FORWARD -i eth0 \
      -s 10.94.4.64/29 \
      -p icmp --icmp-type echo-request -j ACCEPT

  # Memblokir seluruh trafik lainnya dari jaringan luar
  iptables -A FORWARD -i eth0 -j DROP
  ```

### 3. Pengujian & Analisis Hasil

1. **Pengujian Ping dari Magi-Casper ke Zeruel:**

   ```bash
   ping -c 3 10.94.4.90
   ```

   *Hasil:* Pengujian ping berhasil dengan `0% packet loss`. Hal ini membuktikan bahwa paket ICMP dari Magi-Casper yang berasal dari subnet Terminal (`10.94.4.64/29`) berhasil melewati aturan pengecualian sebelum mencapai rule `DROP`.

2. **Pengujian Ping dari Lilith ke Zeruel:**

   ```bash
   ping -c 3 10.94.4.90
   ```

   *Hasil:* Pengujian ping gagal dengan `100% packet loss` karena paket ICMP dari Lilith masuk melalui interface `eth0` dan tidak termasuk dalam subnet Terminal yang mendapatkan pengecualian. Oleh karena itu, paket dijatuhkan oleh aturan `-i eth0 -j DROP`.

3. **Verifikasi Aturan Firewall FORWARD pada Shigeru:**

   ```bash
   iptables -L FORWARD -v -n --line-numbers
   ```

   *Hasil:* Terlihat tiga aturan firewall pada rantai `FORWARD`, yaitu `ESTABLISHED,RELATED`, pengecualian ICMP dari subnet Terminal, dan `DROP` untuk seluruh trafik lainnya dari `eth0`. Nilai *packet counter* menunjukkan aktivitas paket yang diproses oleh masing-masing aturan.

### DOKUMENTASI

1. Hasil verifikasi aturan firewall FORWARD menggunakan perintah `iptables -L FORWARD -v -n --line-numbers` pada Shigeru.
   ![alt text](assets/image-29.png)
2. Hasil pengujian ping dari Magi-Casper ke Zeruel (`10.94.4.90`) yang berhasil.
   ![alt text](assets/image-30.png)
3. Hasil pengujian ping dari Lilith ke Zeruel (`10.94.4.90`) yang gagal.
   ![alt text](assets/image-31.png)

## Soal 19: Isolasi Node Armisael Tanpa Mengganggu Konektivitas Zeruel

### 1. Penjelasan Konsep

Pada tahap ini dilakukan penerapan mekanisme isolasi jaringan terhadap perangkat **Armisael** (`10.94.4.91/29`, MAC `02:42:3f:0c:ec:00`) menggunakan firewall **iptables** pada router gateway **Shigeru**.

Tujuan konfigurasi ini adalah memblokir seluruh lalu lintas masuk dan keluar Armisael tanpa melakukan perubahan konfigurasi di dalam node Armisael maupun mengisolasi seluruh Switch-Monolith yang juga menghubungkan perangkat Zeruel (`10.94.4.90/29`).

Terdapat beberapa mekanisme yang diterapkan:

- **Pemblokiran pada rantai INPUT:** Menggunakan aturan `-s 10.94.4.91 -j DROP` untuk menjatuhkan paket yang berasal dari Armisael dan ditujukan ke router Shigeru.
- **Pemblokiran pada rantai FORWARD:** Menggunakan aturan `-s 10.94.4.91 -j DROP` dan `-d 10.94.4.91 -j DROP` untuk memblokir trafik yang berasal dari maupun menuju Armisael ketika melewati router Shigeru.
- **Mempertahankan aturan firewall sebelumnya:** Aturan `ESTABLISHED,RELATED`, pengecualian ICMP dari subnet Terminal, serta pemblokiran trafik masuk dari interface `eth0` tetap dipertahankan.
- **Mempertahankan konektivitas Zeruel:** Pemblokiran dilakukan berdasarkan alamat IP Armisael, bukan berdasarkan keseluruhan segmen atau Switch-Monolith, sehingga Zeruel tidak ikut terkena aturan isolasi.

Karena Armisael dan Zeruel berada dalam satu subnet `10.94.4.88/29` dan terhubung melalui Switch-Monolith, komunikasi langsung di antara keduanya tidak melewati router Shigeru. Oleh karena itu, isolasi menggunakan firewall gateway tidak dapat memutus komunikasi Layer 2 secara langsung di antara kedua perangkat.

### 2. Skrip Konfigurasi Isolasi pada Router Shigeru

- **Router `Shigeru` (`/root/shigeru.sh`):**

  ```bash
  #!/bin/sh

  IF_GENDO="eth0"
  SUBNET_TERMINAL="10.94.4.64/29"
  ARMISAEL_IP="10.94.4.91"

  # Konfigurasi IP interface & routing Shigeru
  ip addr flush dev eth0; ip addr add 10.94.4.114/30 dev eth0; ip link set eth0 up
  ip addr flush dev eth1; ip addr add 10.94.4.89/29 dev eth1; ip link set eth1 up
  ip addr flush dev eth2; ip addr add 10.94.4.145/30 dev eth2; ip link set eth2 up

  sysctl -w net.ipv4.ip_forward=1 >/dev/null

  ip route replace default via 10.94.4.113
  ip route replace 10.94.4.56/29 via 10.94.4.146

  # Isolasi Armisael pada rantai INPUT
  iptables -D INPUT -s "$ARMISAEL_IP" -j DROP 2>/dev/null || true
  iptables -I INPUT 1 -s "$ARMISAEL_IP" -j DROP

  # Konfigurasi firewall FORWARD
  iptables -F FORWARD
  iptables -P FORWARD ACCEPT

  # Memblokir trafik dari Armisael
  iptables -A FORWARD -s "$ARMISAEL_IP" -j DROP

  # Memblokir trafik menuju Armisael
  iptables -A FORWARD -d "$ARMISAEL_IP" -j DROP

  # Mengizinkan koneksi yang sudah terbentuk
  iptables -A FORWARD -m conntrack \
      --ctstate ESTABLISHED,RELATED -j ACCEPT

  # Pengecualian ICMP dari subnet Terminal
  iptables -A FORWARD -i "$IF_GENDO" \
      -s "$SUBNET_TERMINAL" \
      -p icmp --icmp-type echo-request -j ACCEPT

  # Memblokir trafik lainnya dari jaringan luar
  iptables -A FORWARD -i "$IF_GENDO" -j DROP
  ```

### 3. Pengujian & Analisis Hasil

1. **Pengujian Konektivitas dari Armisael ke Lilith:**

   ```bash
   ping -c 2 10.94.4.82
   nc -v -w 3 10.94.4.82 53
   nc -v -w 3 10.94.4.82 9000
   ```

   *Hasil:* Seluruh pengujian konektivitas gagal. Pengujian ping menghasilkan `100% packet loss`, sedangkan koneksi TCP ke port `53` dan `9000` gagal atau mengalami `timed out`. Hal ini menunjukkan bahwa trafik Armisael yang melewati Shigeru berhasil dibatasi oleh aturan firewall.

2. **Pengujian Konektivitas Armisael ke Zeruel:**

   ```bash
   ping -c 2 10.94.4.90
   nc -v -w 3 10.94.4.90 9000
   ```

   *Hasil:* Pengujian ping berhasil dengan `0% packet loss` dan koneksi TCP port `9000` menunjukkan `succeeded`. Hal ini terjadi karena Armisael dan Zeruel berada dalam satu subnet `/29` (`10.94.4.88/29`) sehingga komunikasi keduanya berlangsung langsung melalui Switch-Monolith tanpa melewati rantai `FORWARD` pada Shigeru.

3. **Pengujian Konektivitas dari Zeruel ke Lilith:**

   ```bash
   ping -c 2 10.94.4.82
   nc -v -w 3 10.94.4.82 53
   nc -v -w 3 10.94.4.82 9000
   ```

   *Hasil:* Seluruh pengujian konektivitas dari Zeruel ke Lilith berhasil. Ping mendapatkan respons dan koneksi TCP menuju port `53` serta `9000` berhasil. Hal ini membuktikan bahwa aturan isolasi berdasarkan alamat IP Armisael tidak ikut memblokir konektivitas Zeruel.

4. **Verifikasi Aturan Firewall pada Shigeru:**

   ```bash
   iptables -L INPUT -v -n --line-numbers
   iptables -L FORWARD -v -n --line-numbers
   ```

   *Hasil:* Terlihat aturan `DROP` khusus alamat IP Armisael pada rantai `INPUT` dan `FORWARD`, serta aturan firewall zona Monolith/Radar yang tetap dipertahankan. Nilai *packet counter* menunjukkan paket yang diproses oleh masing-masing aturan firewall.

### DOKUMENTASI

1. Hasil pengujian ping dan koneksi TCP dari Armisael ke Lilith serta pengujian konektivitas Armisael ke Zeruel.
   ![alt text](assets/image-32.png)
2. Hasil pengujian ping dan koneksi TCP dari Zeruel ke Lilith pada port `53` dan `9000`.
   ![alt text](assets/image-33.png)
3. Hasil verifikasi aturan firewall INPUT dan FORWARD menggunakan perintah `iptables -L INPUT -v -n --line-numbers` dan `iptables -L FORWARD -v -n --line-numbers` pada Shigeru.
   ![alt text](assets/image-34.png)

## Soal 20: Uji Kebakaran Geofront (Backup & Pemulihan Firewall serta Routing)

### 1. Penjelasan Konsep

Pada tahap ini dilakukan pengujian kesiapan pemulihan sistem jaringan (*disaster recovery*) untuk memastikan konfigurasi firewall dan routing dapat dikembalikan dengan cepat, konsisten, dan idempoten setelah terjadi penghapusan aturan maupun rute.

Pengujian dilakukan pada tiga node, yaitu **Shigeru** sebagai router, serta **Zeruel** dan **Lilith** sebagai host. Terdapat empat tahapan utama dalam proses pengujian:

- **Backup Konfigurasi Firewall:** Menyimpan seluruh aturan firewall yang sedang aktif ke dalam berkas `/root/<nama>.rules` menggunakan perintah `iptables-save`.
- **Simulasi Penghapusan Konfigurasi:** Menghapus aturan pada tabel `filter`, `nat`, `mangle`, dan `raw`, mengembalikan *default policy* menjadi `ACCEPT`, serta menghapus rute yang telah ditambahkan secara manual.
- **Pemulihan Konfigurasi:** Mengembalikan aturan firewall menggunakan `iptables-restore` dan menjalankan kembali skrip konfigurasi `/root/<nama>.sh` sebanyak dua kali berturut-turut untuk menguji sifat idempoten.
- **Verifikasi Konsistensi Sistem:** Membandingkan jumlah baris aturan firewall antara pemulihan pertama dan kedua, memeriksa tabel routing menggunakan `ip r`, serta menguji konektivitas dan layanan jaringan menggunakan `ping`, `nc`, dan `ss`.

Dengan mekanisme tersebut, konfigurasi dapat dipulihkan tanpa menghasilkan aturan firewall maupun rute yang terduplikasi ketika proses pemulihan dijalankan berulang kali.

### 2. Skrip Backup dan Pemulihan per Node

#### a. Router `Shigeru` (`/root/shigeru.sh`)

```bash
#!/bin/sh

IF_GENDO="eth0"
SUBNET_TERMINAL="10.94.4.64/29"
ARMISAEL_IP="10.94.4.91"

# Konfigurasi IP interface & routing Shigeru
ip addr flush dev eth0; ip addr add 10.94.4.114/30 dev eth0; ip link set eth0 up
ip addr flush dev eth1; ip addr add 10.94.4.89/29 dev eth1; ip link set eth1 up
ip addr flush dev eth2; ip addr add 10.94.4.145/30 dev eth2; ip link set eth2 up

sysctl -w net.ipv4.ip_forward=1 >/dev/null

ip route replace default via 10.94.4.113
ip route replace 10.94.4.56/29 via 10.94.4.146

# Isolasi Armisael pada rantai INPUT
iptables -D INPUT -s "$ARMISAEL_IP" -j DROP 2>/dev/null || true
iptables -I INPUT 1 -s "$ARMISAEL_IP" -j DROP

# Aturan FORWARD zona Monolith & Radar
iptables -F FORWARD
iptables -P FORWARD ACCEPT
iptables -A FORWARD -s "$ARMISAEL_IP" -j DROP
iptables -A FORWARD -d "$ARMISAEL_IP" -j DROP
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i "$IF_GENDO" -s "$SUBNET_TERMINAL" -p icmp --icmp-type echo-request -j ACCEPT
iptables -A FORWARD -i "$IF_GENDO" -j DROP
```

#### b. Node `Zeruel` (`/root/zeruel.sh`)

```bash
#!/bin/sh

ip link set eth0 up
ip route replace default via 10.94.4.89 dev eth0
```

#### c. Node `Lilith` (`/root/lilith.sh`)

```bash
#!/bin/sh

ip link set eth0 up
ip route replace default via 10.94.4.81 dev eth0
```

### 3. Hasil Pengujian & Analisis

1. **Pengujian Backup, Penghapusan, dan Pemulihan pada Shigeru:**

   *Hasil:* Konfigurasi firewall berhasil dicadangkan menggunakan `iptables-save`, kemudian aturan firewall dan rute diuji dengan simulasi penghapusan. Pemulihan dilakukan menggunakan `iptables-restore` dan skrip `/root/shigeru.sh` sebanyak dua kali berturut-turut. Hasil perbandingan menunjukkan jumlah aturan `iptables -S` tetap `9` baris dan `iptables -t nat -S` tetap `4` baris pada kedua proses pemulihan. Tabel routing kembali menampilkan default route melalui `10.94.4.113` dan rute `10.94.4.56/29` melalui `10.94.4.146` tanpa duplikasi. Pengujian `ping -c 2 10.94.4.113` dan `ping -c 2 10.94.4.82` berhasil dengan `0% packet loss`.

2. **Pengujian Backup, Penghapusan, dan Pemulihan pada Zeruel:**

   *Hasil:* Konfigurasi firewall berhasil dicadangkan dan dipulihkan sebanyak dua kali berturut-turut. Jumlah aturan `iptables -S` tetap `3` baris dan `iptables -t nat -S` tetap `4` baris. Default route melalui `10.94.4.89` pada interface `eth0` berhasil dipulihkan tanpa duplikasi. Pengujian `ping -c 2 10.94.4.82` berhasil dengan `0% packet loss`, serta koneksi TCP menuju Lilith pada port `53` dan `9000` berhasil menggunakan `nc`.

3. **Pengujian Backup, Penghapusan, dan Pemulihan pada Lilith:**

   *Hasil:* Konfigurasi firewall berhasil dicadangkan dan dipulihkan sebanyak dua kali berturut-turut. Jumlah aturan `iptables -S` tetap `3` baris dan `iptables -t nat -S` tetap `4` baris. Default route melalui `10.94.4.81` pada interface `eth0` berhasil dipulihkan tanpa duplikasi. Pengujian `ping -c 2 10.94.4.81` berhasil dengan `0% packet loss`, sedangkan listener TCP port `53` dan `9000` kembali aktif dengan status `LISTEN`.

4. **Verifikasi Konsistensi Firewall dan Routing:**

   *Hasil:* Ketiga node berhasil melewati proses pemulihan tanpa menghasilkan aturan firewall maupun rute yang terduplikasi. Jumlah baris aturan firewall pada pemulihan pertama dan kedua menunjukkan hasil identik. Konektivitas jaringan serta layanan pada masing-masing node kembali berjalan sesuai konfigurasi sebelumnya. Dengan demikian, mekanisme backup dan pemulihan berhasil memenuhi pengujian idempotensi.

### DOKUMENTASI

1. Hasil pengujian backup, penghapusan konfigurasi, pemulihan pertama dan kedua, serta verifikasi firewall dan routing pada Shigeru.
   <div align="center">
      <img src="assets/image-35.png" width="48%">
      <img src="assets/image-36.png" width="48%">
   </div>
2. Hasil pengujian backup, penghapusan konfigurasi, pemulihan pertama dan kedua, serta verifikasi firewall dan routing pada Zeruel.
   <div align="center">
      <img src="assets/image-37.png" width="48%">
      <img src="assets/image-38.png" width="48%">
   </div>

3. Hasil pengujian backup, penghapusan konfigurasi, pemulihan pertama dan kedua, serta verifikasi firewall dan routing pada Lilith.
   <div align="center">
      <img src="assets/image-39.png" width="48%">
      <img src="assets/image-40.png" width="48%">
   </div>