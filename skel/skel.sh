#! /usr/bin bash
########################################################################
# AUTHOR    : XENTA OS
# LICENSE   : GNU GPL 3.0
# WEBSITE   : http://www.xentaos.com/
########################################################################

# Pertama silahkan buat file iso yang sudah diremaster dan sudah di sertakan theme, icons dan wallpaper

# Dibutuhkan flashdisk atau micro sd

# Silahkan booting live cdnya
# silahkan setting pengaturan theme, icons dan wallpaper dan setting lain lain
# jika sudah silahkan logout
# login lagi
# Ketik perintak berikut di derektoro user home
tar -zcvf artwork.tar.gz .config .dconf .mozilla

# silahkan copy file artwork.tar.gz ke flasdisk atau micro sd
# silahkan matikan komputer dan jalankan mode biasa

# copykan file artwork.tar.gz dan extact
# hapus folder .config .gconf .cinnamon .mozilla di /livecdtmp/edit/etc/skel/
# copykan folder artwork yang sudah diextrack .config .gconf .cinnamon .mozilla ke folder livecdtmp/edit/etc/skel/
