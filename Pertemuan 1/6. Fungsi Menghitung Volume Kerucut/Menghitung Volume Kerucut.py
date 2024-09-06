def hitung_volume_kerucut(diameter, tinggi):
  jari_jari = diameter / 2
  pi = 3.14
  volume = (1/3) * pi * jari_jari * jari_jari * tinggi
  return volume

hasil = hitung_volume_kerucut(5, 4)
print("Volume kerucut adalah:", hasil, "cm³")