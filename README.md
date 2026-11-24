# Laporan Praktikum Jaringan Komputer: Topologi Geofront (Soal 1 – 10)

---

## Soal 1: Perhitungan VLSM & Pembagian Subjaringan

### 1. Penjelasan Konsep & Metode

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

- **File Excel Tabel VLSM:** [K61_TABEL_VLSM.xlsx](assets/K61_TABEL_VLSM.xlsx)

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

- **Bukti Dokumentasi:**
  ![Error APT Clock di Casper](dokumentasi/Soal07_01_Casper_Error_APT_Clock.png)
  ![Error APT Clock di Balthasar](dokumentasi/Soal07_02_Balthasar_Error_APT_Clock.png)
  ![Error APT Clock di Melchior](dokumentasi/Soal07_03_Melchior_Error_APT_Clock.png)
  ![Instalasi & Listener Casper Berhasil](dokumentasi/Soal07_04_Casper_Install_Listener_OK.png)
  ![Instalasi & Listener Balthasar Berhasil](dokumentasi/Soal07_05_Balthasar_Install_Listener_OK.png)
  ![Instalasi & Listener Melchior Berhasil](dokumentasi/Soal07_06_Melchior_Install_Listener_OK.png)
  ![Pengiriman Pesan dari Lilith](dokumentasi/Soal07_07_Lilith_Kirim_Pesan_MAGI.png)
  ![Log Pesan Masuk di Casper](dokumentasi/Soal07_08_Casper_Log_Pesan_Diterima.png)
  ![Log Pesan Masuk di Balthasar](dokumentasi/Soal07_09_Balthasar_Log_Pesan_Diterima.png)
  ![Log Pesan Masuk di Melchior](dokumentasi/Soal07_10_Melchior_Log_Pesan_Diterima.png)

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

- **Bukti Dokumentasi:**
  ![Aktivasi Listener Pen-Pen Port 80](dokumentasi/Soal08_01_PenPen_Listener_Port80.png)
  ![Aktivasi Listener Tokyo3-Core Port 80 & 8080](dokumentasi/Soal08_02_Tokyo3Core_Listener_Port80_8080.png)
  ![Pengujian Port 80, 8080, dan 22 dari Lilith](dokumentasi/Soal08_03_Lilith_Uji_NC_Port80_8080_22.png)

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

- **Bukti Dokumentasi:**
  ![Referensi Skrip break_routing.sh](dokumentasi/Soal09_01_Referensi_Script_break_routing.png)
  ![Eksekusi break_routing.sh di Shigeru](dokumentasi/Soal09_02_Shigeru_Eksekusi_break_routing.png)
  ![Inspeksi 4 Penyebab Sabotase di Shigeru](dokumentasi/Soal09_03_Shigeru_Inspeksi_4_Penyebab_Sabotase.png)
  ![Gejala Ping Gagal dari Lilith ke Armisael](dokumentasi/Soal09_04_Lilith_Gejala_Ping_Armisael_Gagal.png)
  ![Perbaikan Routing & Rule di Shigeru](dokumentasi/Soal09_05_Shigeru_Perbaikan_Routing_Rule_Forward.png)
  ![Verifikasi Ping Armisael Kembali Normal](dokumentasi/Soal09_06_Lilith_Verifikasi_Ping_Armisael_Normal.png)

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

- **Bukti Dokumentasi:**
  ![Referensi Skrip break_nat.sh](dokumentasi/Soal10_01_Referensi_Script_break_nat.png)
  ![Eksekusi break_nat.sh di Misato](dokumentasi/Soal10_03_Misato_Eksekusi_break_nat.png)
  ![Eksekusi break_nat.sh di Gendou](dokumentasi/Soal10_04_Gendou_Eksekusi_break_nat.png)
  ![Tabel NAT Rusak di Misato (SNAT Palsu)](dokumentasi/Soal10_05_Misato_Tabel_NAT_SNAT_Palsu.png)
  ![Tabel NAT Rusak di Gendou (Bypass RETURN)](dokumentasi/Soal10_06_Gendou_Tabel_NAT_Bypass_RETURN.png)
  ![Gejala Ping 8.8.8.8 Gagal & Lilith Sukses di Unit-01](dokumentasi/Soal10_07_Unit01_Gejala_Ping_8888_Gagal_Lilith_OK.png)
  ![Uji Ping 8.8.8.8 Normal di Spy](dokumentasi/Soal10_08_Spy_Ping_8888_Normal.png)
  ![Perbaikan Tabel NAT di Misato](dokumentasi/Soal10_09_Misato_Perbaikan_Flush_NAT.png)
  ![Perbaikan Tabel NAT di Gendou](dokumentasi/Soal10_10_Gendou_Perbaikan_Hapus_Rule_RETURN.png)
  ![Verifikasi Ping 8.8.8.8 Kembali Normal dari Unit-01](dokumentasi/Soal10_11_Unit01_Verifikasi_Ping_8888_Normal.png)
