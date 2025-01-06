# Reminder (Seviye: Orta)
1 veya 2 ekranlı basit bir reminder app'i yap.
Ana ekranda yapılacaklar listesi olsun. Bu liste sonsuza kadar uzayabilir. En yakın zamandan geleceğe doğru sıralansın. Önce tamamlanmayanlar gösterilsin.
Navigation Bar'ın olduğu yerde horizontal bir şekilde tarih gösterilsin. Opsiyonel olarak bu tarihi scroll etme ekleyebilirsin.
App'in açıldığı zamana göre **Good Morning**, **Good Night** tarzında bilgilendirme yapılsın.
Ana ekranda sağ alttaki **+** butonuna basarak task oluşturma ekranı gelsin. Bu ekranı popup olarak da tasarlayabilirsin, yeni bir ekran olarak da. Yeni ekran olarak Navigation Controller ile açılması daha iyi olur. Opsiyonel olarak popup yapabilirsin.
Opsiyonel olarak cihazın moduna göre Light/Dark mode desteği verebilirsin. Eğer vermeyecek isen Light/Dark tasarımlarından birini seçip uygulayabilirsin.

## Tasarım
Tasarımı incelemek için .fig uzantılı [tasarım dosyasını](https://github.com/icommunitycomtr/reminder/blob/main/iCommunity-Reminder.fig) indirip Figma'ya import alabilirsiniz.

Tasarımı olabildiğince koda dökmeye çalışın. Gerçek bir iş deneyimi gibi olsun.

Tasarımda iOS ekosistemine aykırı durum var ise düzelterek ekosisteme uygun hale getirin.

## Hedef
- Düzenli bir **folder structure** kurabilmek
- **Controller**, **View** ve **View Model** arasındaki ilişkiyi anlamak
- Reusable şekilde TableView/CollectionView kullanabilmek
- ViewModel'da mantıksal işlemler yapabilmek

## Mimari
En basit şekilde **MVVM+Protocol** kullan.

## Dil / Framework
Swift ve UIKit

## Responsive Design
- İster **Storyboard** ister programmatically olarak UI'ı oluşturabilirsin. Eğer UI oluşturmada kendini zayıf hissediyorsan Storyboard kullanmanı tavsiye ederim.
- Yapılacaklar listesi için TableView/CollectionView kullanabilirsin. Eğer aksi bir durum yok ise **CollectionView** kullanmanı tavsiye ederim.
- Tasarımın tüm iPhone'larda düzgün göründüğünden emin ol

## Akış
Yapılacaklar listesini bir array ile kontrol et. Bu array'i UserDefaults'ta tutarak app her açıldığında çekebilirsin. Kullanıcı oluşturduğu task'ları checkbox'a basarak tamamlayabilir. 

## Anahtar Kelimeler
- MVVM
- Protocol
- Storyboard
- Auto Layout
- Programmatically
- Collection View
- Table View
- UserDefaults
