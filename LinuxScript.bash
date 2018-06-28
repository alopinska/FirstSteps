#!/bin/bash
delay_time=2
system_info_file="systemInfo.txt"
userid=$(id -u)
line="-------------------------------------------------------------------------------"

#funkcja tworząca plik z informacjami o systemie
system_file()
{
if [ -f $system_info_file ]; then
	rm $system_info_file
	echo "Usunięcie istniejącego pliku $system_info_file"
	touch $system_info_file
        echo "Utworzono nowy plik $system_info_file"
else
	touch $system_info_file
	echo "Utworzono nowy plik $system_info_file"
sleep $delay_time
fi
}

#funkcja zbierająca i zapisująca dane do pliku
display_info()
{
echo "************* Informacje o systemie *****************"	>> $system_info_file
echo -n "Zalogowany użytkownik: "				>> $system_info_file
whoami								>> $system_info_file
echo "Katalog domowy: " $HOME					>> $system_info_file
echo "Informacje o pamięci: "					>> $system_info_file
echo  $line							>> $system_info_file
free								>> $system_info_file
echo $line							>> $system_info_file
echo " "							>> $system_info_file
echo "Całkowita przestrzeń na dysku: "				>> $system_info_file
echo $line							>> $system_info_file
df								>> $system_info_file
echo $line							>> $system_info_file
echo "Przestrzeń katalogu użytkownika: "			>> $system_info_file
du -sh $HOME							>> $system_info_file
echo " "							>> $system_info_file
echo $line							>> $system_info_file
cat $system_info_file
read -p "Wciśnij dowolny klawisz aby kontynuować... >"
}
#funkcja tworząca grupę
group_add()
{
if [ $userid = "0" ]; then
	echo  -n "Podaj nazwę grupy: "
	read group	
	if grep -q $group /etc/group
	then
	echo "Grupa o podanej nazwie istnieje. Przerywam działanie funkcji."
	else
	echo "Dodano nową grupę."
	groupadd $group
	fi
else
	echo "Nie masz uprawnień, by korzystać z tej funkcji. "
fi
sleep $delay_time
}
#funkcja tworząca użytkownika i dodająca go do grupy
user_add()
{
if [ $userid = "0" ]; then
	echo -n "Podaj nazwę użytkownika: "
	read user
	getent passwd $user > /dev/null
	if [ $? -eq 0 ]; then	
		echo "Użytkownik o podanej nazwie już istnieje."
		echo -n "Podaj nazwę grupy, do której ma zostać przypisany użytkownik: "
		read group
		if grep -q $group /etc/group
                then
                echo "Grupa o podanej nazwie istnieje. Dodaję użytkownika."
                usermod -a -G $group $user
                passwd $user
		else
                echo "Grupa o podanej nazwie nie istnieje. Utwórz grupę za pomocą opcji nr 3 w menu."
		fi
	else
		useradd $user
		echo "Dodano użytkownika $user"
		echo -n "Podaj nazwę grupy, do której użytkownik ma zostać dodany: "
		read group
		if grep -q $group /etc/group
        	then
        	echo "Grupa o podanej nazwie istnieje. Dodaję użytkownika."
		usermod -a -G $group $user
		passwd $user
        	else
        	echo "Grupa o podanej nazwie nie istnieje. Utwórz grupę za pomocą opcji nr 3 w menu."
		fi
	fi
else
	echo "Nie masz uprawnień, by korzystać z tej funkcji. "
fi
sleep $delay_time
}
#funkcja pobierająca i przetwarzająca plik
get_file()
{
mkdir ~/repository
check=$(ls ~/repository -A | wc -l)
	if [ $check -gt '0' ] ; then
		echo "W katalogu docelowym znajdują się pliki. Czy chcesz je usunąć? (y|n) > "
		read answer
		if [ $answer = 'y' ] ; then
			rm -r ~/repository/*
			echo "Usuwanie zawartości katalogu."
			wget http://corecontrol.cba.pl/linuxlab.tar -P ~/repository
			echo "Pobieranie zawartości..."
			tar xvf ~/repository/linuxlab.tar -C ~/repository
			echo "Katalog został uzupełniony."
			make_tree
		else
		echo "Zawartość katalogu repository nie zostanie usunięta. Przerywam działanie funkcji."
		fi
	else
		wget http://corecontrol.cba.pl/linuxlab.tar -P ~/repository
                echo "Pobieranie zawartości..."
                tar xvf ~/repository/linuxlab.tar -C ~/repository
                echo "Katalog został uzupełniony."
		make_tree
	fi
read -p "Wciśnij dowolny klawisz aby kontynuować... >"
}

#funkcja tworząca drzewo z katalogi.txt
make_tree()
{
find  ~/repository/linuxlab -name katalogi.txt
if [ $? -eq 0 ]; then
echo "Plik o nazwie katalogi.txt istnieje. Rozpoczynam weryfikację miejsca na podkatalogi."
       if [ -d ~/content ]; then
            echo -n "Ścieżka content na podkatalogi istnieje. Czy chcesz usunąć jej zawartość? (y|n)"
            read answer
            if [ $answer = "y" ]; then
               rm -r ~/content
	       mkdir ~/content	
               echo "Usuwanie zawartości katalogu content..."
               xargs -I {} mkdir -p ~/content/{} < ~/repository/linuxlab/katalogi.txt
               echo "Drzewo podkatalogów zostało utworzone. Przerywam działanie funkcji."
            else
            echo "Zawartość katalogu content nie zostanie usunięta. Przerywam działanie funkcji."
            fi
       else
       mkdir ~/content/
       xargs -I {} mkdir -p ~/content/ < ~/repository/linuxlab/katalogi.txt
       echo "Drzewo podkatalogów zostało utworzone. Przerywam działanie funkcji."
       fi
else
echo "Plik katalogi.txt nie istnieje. Przerywam działanie funkcji."
fi
sleep $delay_time
}
#funkcja wyszukująca wprowadzone słowo w plikach tekstowych z pobranego katalogu
find_word()
{
if [ -d ~/repository/linuxlab/teksty/ ]; then
	echo "Istnieją pliki do przeszukania. Wprowadź słowo do wyszukania: "
	read word
	if grep -i $word ~/repository/linuxlab/teksty/*.txt
	then
	echo "Zakończono przetwarzanie ciągu znaków."
	else
	echo "Przykro mi, tego słowa nie ma w przeszukiwanych plikach"
	fi
else
	echo "Brak plików do przeszukania. Wykonaj krok 5, żeby pobrać teksty."
fi
read -p "Wciśnij dowolny klawisz aby kontynuować... >"

}


#funkcja obsługująca menu główne skryptu
menu()
{
while [ "$value" != 0 ]
do
clear
echo -e "1) Zbierz informacje o systemie\n2) Wyświetl zapisane informacje\n3) Utwórz grupę\n4) Utwórz użytkownika\n5) Pobierz i przetwórz plik\n6) Wyszukaj frazy w plikach\n0) Opuść skrypt"
echo -n "Wybierz opcję [1,2,3,4,5,6 lub 0]> "
read value
	case $value in
		1) system_file;;
		2) display_info;;
		3) group_add;;
		4) user_add;;
		5) get_file;;
		6) find_word;;
		0) echo "Opuszczam skrypt..." ;;
		*)
		   echo "Nie wybrałeś żadnej z wartości"
	esac
sleep $delay_time
done
}
menu
 




