﻿

#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("АдресЗначения", АдресЗначения); 
	
	Значение = ПолучитьИзВременногоХранилища(АдресЗначения);
	
	Для Каждого Колонка ИЗ Значение.Колонки Цикл
		ДобавитьКолонку(Колонка.Имя, Колонка.ТипЗначения, "ТаблицаЗначений");
	КонецЦикла; 
	
	ТаблицаЗначений.Загрузить(Значение);
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы  

&НаКлиенте
Процедура КолонкиПриИзменении(Элемент)
	
	Элементы.ПрименитьИзмененияКолонок.Доступность = Истина;
	//Элементы.ТаблицаЗначений.ТолькоПросмотр = Истина;
	Элементы.КолонкиОтменитьРедактированиеКолонок.Доступность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
 &НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(); 
	
КонецПроцедуры  

&НаКлиенте
Процедура Перенести(Команда)
	
	ПоместитьТаблицуВХранилище();	
	Закрыть(Истина); 
	
КонецПроцедуры  

&НаКлиенте
Процедура ПрименитьИзмененияКолонок(Команда)  

	Если Не ПроверитьЗаполнение() Тогда
		Возврат
	КонецЕсли;
	
	ПрименитьИзмененияКолонокНаСервере();	
	
	Элементы.ПрименитьИзмененияКолонок.Доступность = Ложь;  
	Элементы.КолонкиОтменитьРедактированиеКолонок.Доступность = Ложь;
	//Элементы.ТаблицаЗначений.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьРедактированиеКолонок(Команда)
	
	Колонки.Очистить();
	
	Для Каждого Колонка Из КолонкиКорректировка Цикл
		ЗаполнитьЗначенияСвойств(Колонки.Добавить(), Колонка);
	КонецЦикла;
		
	Элементы.ПрименитьИзмененияКолонок.Доступность = Ложь;  
	Элементы.КолонкиОтменитьРедактированиеКолонок.Доступность = Ложь;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

&НаСервере
Функция ДобавитьКолонку(ИмяЭлемента, ТипЗначения, ИмяТаблицы, СоздатьЭлемент = Истина, ДобавитьВКолонки = Истина);
	
	Реквизит = Новый РеквизитФормы(ИмяЭлемента, ТипЗначения, ИмяТаблицы);
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(Реквизит); 
	Попытка  // TODO отловить ошибку, на каком типе происходит исключение.
		ИзменитьРеквизиты(МассивРеквизитов); 
	Исключение       
		Реквизит.ТипЗначения = Новый ОписаниеТипов();
		ИзменитьРеквизиты(МассивРеквизитов); 
	КонецПопытки;
	
	Если СоздатьЭлемент Тогда
		НовыйЭлемент = Элементы.Добавить(ИмяЭлемента, Тип("ПолеФормы"), Элементы[ИмяТаблицы]);		
		НовыйЭлемент.ПутьКДанным = ИмяТаблицы + "." + ИмяЭлемента;
		НовыйЭлемент.Вид = ВидПоляФормы.ПолеВвода;
	КонецЕсли;
	
	Если ДобавитьВКолонки Тогда
		СтрокаКолонки = Колонки.Добавить();
		СтрокаКолонки.Имя = ИмяЭлемента;
		СтрокаКолонки.ТипЗначения = ТипЗначения; 
		ЗаполнитьЗначенияСвойств(КолонкиКорректировка.Добавить(), СтрокаКолонки);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПоместитьТаблицуВХранилище() 
	ПоместитьВоВременноеХранилище(ТаблицаЗначений.Выгрузить(), АдресЗначения);
КонецПроцедуры

&НаСервере
Процедура ПрименитьИзмененияКолонокНаСервере()  
	
	// Создаем новую версию таблицы. Отдельная таблица ТаблицаЗначенийКорректировка используется
	// чтобы вернутся к старой версии в случае ошибки создания новой версии таблицы. 
	Для Каждого Колонка Из Колонки Цикл
		ДобавитьКолонку(Колонка.Имя, Колонка.ТипЗначения, "ТаблицаЗначенийКорректировка", Ложь, Ложь);	
	КонецЦикла;
	
	// Переносим значения
	Для Каждого ТекущаяСтрока Из ТаблицаЗначений Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаЗначенийКорректировка.Добавить(), ТекущаяСтрока);
	КонецЦикла; 
	
	// Очищаем копию таблицы колонок
	КолонкиКорректировка.Очистить();
	
	// Удалим старую таблицу из формы 
	МассивРеквизитов = Новый Массив;
	Для Каждого Реквизит Из ПолучитьРеквизиты("ТаблицаЗначений") Цикл
		МассивРеквизитов.Добавить("ТаблицаЗначений." + Реквизит.Имя);	
		Элементы.Удалить(Элементы.Найти(Реквизит.Имя));
	КонецЦикла;  
	ИзменитьРеквизиты(, МассивРеквизитов); 
	
	// Переносим новую версию в основную таблицу
	Для Каждого Колонка Из Колонки Цикл
		ДобавитьКолонку(Колонка.Имя, Колонка.ТипЗначения, "ТаблицаЗначений",, Ложь);
		ЗаполнитьЗначенияСвойств(КолонкиКорректировка.Добавить(), Колонка)
	КонецЦикла;   
	ТаблицаЗначений.Загрузить(ТаблицаЗначенийКорректировка.Выгрузить());
	
	// Удаляем таблицу корректировки  
	ТаблицаЗначенийКорректировка.Очистить();
	МассивРеквизитов = Новый Массив;
	Для Каждого Реквизит Из ПолучитьРеквизиты("ТаблицаЗначенийКорректировка") Цикл
		МассивРеквизитов.Добавить("ТаблицаЗначенийКорректировка." + Реквизит.Имя);	
	КонецЦикла;  
	ИзменитьРеквизиты(, МассивРеквизитов);
	
	Элементы.ПрименитьИзмененияКолонок.Доступность = Ложь; 
	
КонецПроцедуры

#КонецОбласти
