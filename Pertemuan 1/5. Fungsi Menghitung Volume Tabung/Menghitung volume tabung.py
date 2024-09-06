def hitung_volume_tabung(jari_jari, tinggi):
  pi = 3.14
  volume = pi * jari_jari * jari_jari * tinggi
  return volume

hasil = hitung_volume_tabung(3, 5)
print("Volume tabung adalah:", hasil)