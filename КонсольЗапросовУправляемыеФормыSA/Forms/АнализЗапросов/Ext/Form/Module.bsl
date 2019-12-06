﻿#Область ОписаниеПеременных
&НаСервере
Перем ТекущийОператорЗапроса;
&НаСервере
Перем Условия;
&НаСервере
Перем RegExp;
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Текст") Тогда
		
		Текст = Параметры.Текст;
		ЗаполнитьСтруктуруЗапроса();

	КонецЕсли;
	
	Если Параметры.Свойство("РежимВыбораЧастей") Тогда
		
		Элементы.ФормаОК.Видимость = Ложь;
		Элементы.ФормаПеренестиВыделенные.Видимость = Истина;
		Элементы.ФормаПеренестиВыделенные.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьСтруктураЗапроса();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СтуктураЗапросаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Элементы.Текст.УстановитьГраницыВыделения(ТекущиеДанные.НомерСтрокиНачало,1,ТекущиеДанные.НомерСтрокиКонец,150); // TODO посчитать количество символов последней строки.
	
	ТекущийЭлемент = Элементы.Текст;
	
	Если Поле = Элементы.СтуктураЗапросаКоличествоПредупреждений 
		И ТекущиеДанные.КоличествоПредупреждений > 0 Тогда
		ПоказатьПредупреждение(,ТекущиеДанные.ТекстПредупреждения);
	КонецЕсли;
		 
КонецПроцедуры

&НаКлиенте
Процедура СтуктураЗапросаПриАктивизацииСтроки(Элемент)
	
	ДеревоИндексов.ПолучитьЭлементы().Очистить();
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат
	КонецЕсли;
	
	Если ТекущиеДанные.ЭлементЗапроса = "Источник" Тогда
		Попытка
			ПоказатьИндексы(ТекущиеДанные.ЗначениеЭлемента);	
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Текст);

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтруктуруЗапроса(Команда)
	
	ЗаполнитьСтруктуруЗапроса();
	
	РазвернутьСтруктураЗапроса();
		
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВыделенные(Команда)
	
	МассивЗапросов = Новый Массив;
	
	Для Каждого ИдентификаторСтроки Из Элементы.СтуктураЗапроса.ВыделенныеСтроки Цикл
		
		СтрокаСтруктуры = СтуктураЗапроса.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		СтрокиЗапроса = Новый Массив;
		
		Для Счетчик = СтрокаСтруктуры.НомерСтрокиНачало По СтрокаСтруктуры.НомерСтрокиКонец Цикл
			
			СтрокиЗапроса.Добавить(СтрПолучитьСтроку(Текст, Счетчик));
			
		КонецЦикла;
		
		МассивЗапросов.Добавить(СтрСоединить(СтрокиЗапроса,Символы.ПС));
		
	КонецЦикла;
	
	Закрыть(МассивЗапросов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаСервере
Процедура ЗаполнитьСтруктуруЗапроса();
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Текст);
	
	ТекстФорматированный = СхемаЗапроса.ПолучитьТекстЗапроса();
	Текст = ТекстФорматированный;
	
	Если Найти(Текст,"{") > 0 Тогда // TODO не нашел в СхемаЗапроса как с ними работать, пока оставил так. 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Запрос содержит конструкции построителя запроса (фигурные скобки {}). Структура запроса может быть построена неправильно.";
		Сообщение.Сообщить();
	КонецЕсли;
	
	ЭлементыСтуктураЗапроса = СтуктураЗапроса.ПолучитьЭлементы();	
	ЭлементыСтуктураЗапроса.Очистить();
	
	НомерСтроки = 0;
	КоличествоПакетов = СхемаЗапроса.ПакетЗапросов.Количество();
	КоличествоЗапросовПакета = 0;
	
	Для Каждого Пакет Из СхемаЗапроса.ПакетЗапросов Цикл
		
		ВывестиЗапрос(СтуктураЗапроса,Пакет,"Пакет",НомерСтроки,КоличествоПакетов,КоличествоЗапросовПакета);
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура ВывестиЗапрос(ЭлементРодитель,Запрос,ИмяЭлементаЗапроса,НомерСтроки,КоличествоПакетов = 1,КоличествоЗапросовПакета = 0);
	
		НомерСтроки = НомерСтроки+1;
		ОператорРодитель = ТекущийОператорЗапроса; // Запомним, чтобы вызывающий метод вернулся к своему текущему оператору.
		
		СтрокаЗапрос = ЭлементРодитель.ПолучитьЭлементы().Добавить();
		СтрокаЗапрос.ЭлементЗапроса = ИмяЭлементаЗапроса;
		СтрокаЗапрос.ЗначениеЭлемента = ПредставлениеПакета(КоличествоЗапросовПакета, Запрос.ТаблицаДляПомещения);
		СтрокаЗапрос.НомерСтрокиНачало = НомерСтроки;

		НомерОператора 				= 0;
		КоличествоОператоров 		= Запрос.Операторы.Количество();
		КоличествоПолейОператоров 	= Запрос.Колонки.Количество();
		
		Для Каждого ТекущийОператорЗапроса Из Запрос.Операторы Цикл
			
			НомерОператора = НомерОператора + 1;
			
			СтрокаОператор = СтрокаЗапрос.ПолучитьЭлементы().Добавить();
			СтрокаОператор.ЭлементЗапроса = "Запрос";
			СтрокаОператор.ЗначениеЭлемента = Строка(ТекущийОператорЗапроса.ТипОбъединения);
			СтрокаОператор.НомерСтрокиНачало = НомерСтроки;

			// ПОЛЯ
			Узел = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки-1,СтрокаОператор,"ВыбираемыеПоля");
			ДополнитьВыбираемыеПоляРекурсивно(НомерСтроки,Узел,ТекущийОператорЗапроса.ВыбираемыеПоля);
			
			КоличествоПолейТекущегоОператора = ТекущийОператорЗапроса.ВыбираемыеПоля.Количество();
			
			// Дополним поля NULL
			Для Счетчик = КоличествоПолейТекущегоОператора По КоличествоПолейОператоров-1 Цикл 
				ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Узел, "Поле", "NULL");
			КонецЦикла;
			
			Узел.НомерСтрокиКонец = НомерСтроки;
			
			// ВРЕМЕННАЯ ТАБЛИЦА
			Если НомерОператора = 1
				И Не ПустаяСтрока(Запрос.ТаблицаДляПомещения) Тогда
				НомерСтроки = НомерСтроки + 1;
			КонецЕсли;
			
			// ИСТОЧНИКИ
			ДобавитьИсточники(НомерСтроки,СтрокаОператор,ТекущийОператорЗапроса);
			
			// ОТБОР
			//УвеличитьСчетчикСтрокПередКлючевымСловом(НомерСтроки,Оператор.Отбор);
			ДобавитьПодчиненныйУзел(НомерСтроки,СтрокаОператор,ТекущийОператорЗапроса,"Отбор");
			
			// ГРУППИРОВКА
			УвеличитьСчетчикСтрокПередКлючевымСловом(НомерСтроки,ТекущийОператорЗапроса.Группировка);
			ДобавитьПодчиненныйУзел(НомерСтроки,СтрокаОператор,ТекущийОператорЗапроса,"Группировка");
			
			// ИНДЕКСЫ
			УвеличитьСчетчикСтрокПередКлючевымСловом(НомерСтроки,Запрос.Индекс);
			ДобавитьПодчиненныйУзел(НомерСтроки,СтрокаЗапрос,Запрос,"Индекс");

			СтрокаОператор.НомерСтрокиКонец = НомерСтроки;
			
			Если КоличествоОператоров > 1 
				И НомерОператора <> КоличествоОператоров Тогда // Разделитель операторов
				НомерСтроки = НомерСтроки+4;
			КонецЕсли;
			
		КонецЦикла;
		
		// ПОРЯДОК
		УвеличитьСчетчикСтрокПередКлючевымСловом(НомерСтроки,Запрос.Порядок);
		ДобавитьПодчиненныйУзел(НомерСтроки,СтрокаЗапрос,Запрос,"Порядок");

		// ИТОГИ
		ДобавитьПодчиненныйУзел(НомерСтроки,СтрокаЗапрос,Запрос,"КонтрольныеТочкиИтогов");
			
		СтрокаЗапрос.НомерСтрокиКонец = НомерСтроки;

		Если КоличествоПакетов > 1 Тогда // Разделитель пакетов
			НомерСтроки = НомерСтроки+3;
		КонецЕсли;
		
		ТекущийОператорЗапроса = ОператорРодитель;
		
КонецПроцедуры
	
Процедура ДополнитьВыбираемыеПоляРекурсивно(НомерСтроки,Узел,Коллекция);
	
	Для Каждого Поле Из Коллекция Цикл
		
		Если ТипЗнч(Поле) = Тип("ВложеннаяТаблицаСхемыЗапроса") Тогда
			НовыйУзел = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Узел,"ВложенныеПоля"); 
			ДополнитьВыбираемыеПоляРекурсивно(НомерСтроки,НовыйУзел,Поле.Поля);	
			НомерСтроки = НомерСтроки+1; // Строка псевдонима вложенных полей
			НовыйУзел.НомерСтрокиКонец = НомерСтроки;
		Иначе
			ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Узел, "Поле", Поле);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
		
Функция ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Родитель,ЭлементЗапроса,Значение = Неопределено)
	
	КоличествоСтрок = 1;
	СтарыйНомерСтроки = НомерСтроки;
	ПредставлениеЗначения = Строка(Значение);
	
	Если Не ПустаяСтрока(ПредставлениеЗначения) Тогда
		КоличествоСтрок = СтрРазделить(ПредставлениеЗначения,Символы.ПС).Количество();
	КонецЕсли;
	
	НомерСтроки = НомерСтроки+КоличествоСтрок; // Увеличим счетчик строк
		
	Строка = Родитель.ПолучитьЭлементы().Добавить();
	Строка.ЭлементЗапроса = ЭлементЗапроса;
	Строка.ЗначениеЭлемента = Значение;
	
	Строка.НомерСтрокиНачало = СтарыйНомерСтроки+1;	
	Строка.НомерСтрокиКонец = НомерСтроки;
	
	ПроверитьЭлемент(Строка,Значение);
	
	Возврат Строка;
	
КонецФункции

Функция ДобавитьПодчиненныйУзел(НомерСтроки,Родитель,ЭлементСхемы,ИмяУзла);
	
	Если ЭлементСхемы[ИмяУзла].Количество() = 0 Тогда
		Возврат Ложь
	КонецЕсли;
	
	Узел = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Родитель,ИмяУзла);
	Коллекция = ЭлементСхемы[ИмяУзла];
	
	Для Каждого Элемент Из Коллекция Цикл
		
		//Если ТипЗнч(Элемент) = Тип("ВыражениеСхемыЗапроса") Тогда
		//	ПредставлениеПоля = Строка(Элемент);
		//ИначеЕсли ТипЗнч(Элемент) = Тип("ВыражениеПорядкаСхемыЗапроса") Тогда 
		//	ПредставлениеПоля = Элемент.Элемент;
		//ИначеЕсли ТипЗнч(Элемент) = Тип("ВыражениеИндексаСхемыЗапроса") Тогда 
		//	ПредставлениеПоля = Элемент.Выражение.Псевдоним;
		//Иначе
		//	ПредставлениеПоля = Элемент.ИмяКолонки;	
		//КонецЕсли;
		
		ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Узел, "Поле"+ИмяУзла, Элемент);
		
	КонецЦикла;
	
	Узел.НомерСтрокиКонец = НомерСтроки; 
	
	Возврат Истина;
	
КонецФункции

Функция ДобавитьИсточники(НомерСтроки,Родитель,Оператор);
	
	Если Оператор.Источники.Количество() = 0 Тогда
		Возврат Ложь
	КонецЕсли;
	
	Узел = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Родитель,"Источники");
	Коллекция = Оператор.Источники;
	
	МассивИсточников = Новый Массив;
	
	Для Каждого Источник Из Коллекция Цикл
		
		ПсевдонимТаблицы = Источник.Источник.Псевдоним;
		
		Если МассивИсточников.Найти(ПсевдонимТаблицы) <> Неопределено Тогда
			Продолжить; // Источник уже добавлен
		КонецЕсли;
				
		МассивИсточников.Добавить(ПсевдонимТаблицы);

		Если ТипЗнч(Источник.Источник) = Тип("ВложенныйЗапросСхемыЗапроса") Тогда
			ВывестиЗапрос(Узел,Источник.Источник.Запрос,"ВложенныйЗапрос",НомерСтроки);
			Продолжить;
		КонецЕсли;

		УзелИсточника = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,Узел, "Источник", Источник.Источник.ИмяТаблицы);
		
		Если Источник.Соединения.Количество() > 0 Тогда
			
			УзелСоединений = ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,УзелИсточника, "Соединения");
			НомерСтроки = НомерСтроки-1;
			
			ДобавитьСоединения(НомерСтроки,Узел,УзелСоединений,МассивИсточников,Источник.Соединения);
			УзелСоединений.НомерСтрокиКонец = НомерСтроки;
			
		КонецЕсли;	
					
	КонецЦикла;
	
	Узел.НомерСтрокиКонец = НомерСтроки; 
	
	Возврат Истина;
	
КонецФункции

Функция ДобавитьСоединения(НомерСтроки,УзелИсточников,УзелСоединений,МассивИсточников,Соединения);
	
	Если Соединения.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого Соединение Из Соединения Цикл
			
		ПсевдонимТаблицыСоединения = Соединение.Источник.Источник.Псевдоним;
		
		Если МассивИсточников.Найти(ПсевдонимТаблицыСоединения) = Неопределено Тогда
			
			МассивИсточников.Добавить(ПсевдонимТаблицыСоединения);
			
			Если ТипЗнч(Соединение.Источник.Источник) = Тип("ВложенныйЗапросСхемыЗапроса") Тогда
				ВывестиЗапрос(УзелИсточников,Соединение.Источник.Источник.Запрос,"ВложенныйЗапрос",НомерСтроки);
			Иначе
				ДобавитьЭлементСтруктурыЗапроса(НомерСтроки, УзелИсточников, "Источник", Соединение.Источник.Источник.ИмяТаблицы);
			КонецЕсли;

		КонецЕсли;

		ДобавитьСоединения(НомерСтроки,УзелИсточников,УзелСоединений,МассивИсточников,Соединение.Источник.Соединения);

		ДобавитьЭлементСтруктурыЗапроса(НомерСтроки,УзелСоединений, "УсловиеСоединения", Соединение.Условие);
		
	КонецЦикла;
	
	Возврат Истина;
			
КонецФункции

Функция УвеличитьСчетчикСтрокПередКлючевымСловом(НомерСтроки,Коллекция);
	
	Если Коллекция.Количество() > 0 Тогда
		НомерСтроки = НомерСтроки+1;
		Возврат Истина;	
	Иначе
		Возврат ложь;	
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеПакета(КоличествоЗапросовПакета, ТаблицаДляПомещения)

	Если ПустаяСтрока(ТаблицаДляПомещения) Тогда
		КоличествоЗапросовПакета = КоличествоЗапросовПакета+1;
		Возврат "Запрос пакета "+КоличествоЗапросовПакета;
	Иначе
		Возврат ТаблицаДляПомещения;
	КонецЕсли;

КонецФункции

Функция ПроверитьЭлемент(СтрокаДерева,Значение)
	
	Если Значение = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Значение) = Тип("ВыражениеСхемыЗапроса") Тогда
		ПроверитьВыражениеСхемыЗапроса(СтрокаДерева,Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("ВыражениеПорядкаСхемыЗапроса") Тогда 
		ПроверитьВыражениеСхемыЗапроса(СтрокаДерева,Значение.Элемент);
	ИначеЕсли ТипЗнч(Значение) = Тип("ВыражениеИндексаСхемыЗапроса") Тогда 
		ПроверитьВыражениеСхемыЗапроса(СтрокаДерева,Значение.Выражение);
	КонецЕсли;

	Возврат Истина;
	
КонецФункции

Процедура ПроверитьВыражениеСхемыЗапроса(СтрокаДерева,Значение);
		
	СтруктураВыражения = РазобратьВыражениеСхемыЗапроса(Значение); 
	
	ПроверитьНаПолучениеДанныхЧерезТочку(СтрокаДерева,СтруктураВыражения.Поля);
		
КонецПроцедуры

Функция РазобратьВыражениеСхемыЗапроса(Значение)
	
	Строка = Строка(Значение);
	
	СтруктураВыражения = Новый Структура("Поля,Параметры,Условия,Выражения,Запросы",
		ПолучитьМассивСовпадений(Строка,"[\wа-яА-Я]+([.][\wа-яА-Я]+)+"),//"\w+[.]\w+"),
		ПолучитьМассивСовпадений(Строка,"&[\wа-яА-Я]"), //"&\w+"
		Новый Массив,
		Новый Массив,
		Новый Массив);
	
	//МассивСлов = СтрРазделить(Значение," ");	
	//
	//Для Каждого Слово Из МассивСлов Цикл
	//	
	//	Если СтрНачинаетсяС(Слово,"&") Тогда
	//		СтруктураВыражения.Параметры.Добавить(Слово);
	//	ИначеЕсли Условия.Найти(Слово) Тогда
	//		СтруктураВыражения.Условия.Добавить(Слово);	
	//	Иначе
	//		СтруктураВыражения.Поля.Добавить(Слово);		
	//	КонецЕсли;
	//			
	//КонецЦикла;
	
	// Поля 	
	Возврат СтруктураВыражения;
	
КонецФункции

Процедура ПроверитьНаПолучениеДанныхЧерезТочку(СтрокаДерева,МассивПолей);
	
	// Разыменование ссылочных полей составного типа в языке запросов.
	// https://its.1c.ru/db/v8std#content:2149184303:hdoc
	
	Для Каждого Значение Из МассивПолей Цикл
		
		МассивЭлементовПоля = СтрРазделить(Значение,"."); 
		
		Если МассивЭлементовПоля.Количество() < 2 Тогда
			
			Продолжить;
			
		КонецЕсли;	
		
		ИсточникДанных = ТекущийОператорЗапроса.Источники.НайтиПоПсевдониму(МассивЭлементовПоля[0]);
		
		ТекущееПолеСхемыЗапроса = ИсточникДанных.Источник.ДоступныеПоля.Найти(МассивЭлементовПоля[1]);
		
		Если ТипЗнч(ТекущееПолеСхемыЗапроса) = Тип("ДоступнаяВложеннаяТаблицаСхемыЗапроса") Тогда
			Продолжить; // TODO предусмотреть обработку вложенных полей. 
		КонецЕсли;
		
		ТекущееКоличествоТипов = ТекущееПолеСхемыЗапроса.ТипЗначения.Типы().Количество();
		
		Для НомерЭлемента = 2 По МассивЭлементовПоля.Количество()-1 Цикл
			
			Если ТекущееКоличествоТипов > 1 Тогда
				ВывестиПредупреждение(СтрокаДерева,"Получение данных через точку от составного типа, поле " + ТекущееПолеСхемыЗапроса.Имя);
			КонецЕсли;
			
			ТекущееПолеСхемыЗапроса = ТекущееПолеСхемыЗапроса.Поля.Найти(МассивЭлементовПоля[НомерЭлемента]);
			ТекущееКоличествоТипов = ТекущееПолеСхемыЗапроса.ТипЗначения.Типы().Количество();
			
		КонецЦикла;
			
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьМассивСовпадений(String,Pattern)
	
	ResultArr = New Array;
	
	RegExp.Pattern = Pattern;
	Matches = RegExp.Execute(String);

	If Matches.Count = 0 Then
		Return ResultArr;
	EndIf;
	
	For Item = 0 To Matches.Count - 1 Do 
		ResultArr.Add(Matches.Item(Item).Value);	
	EndDo;
	
	Return ResultArr;
	
КонецФункции

Процедура ВывестиПредупреждение(СтрокаДерева,ТекстСообщения)
	
	СтрокаДерева.ЕстьПредупреждение = Истина;
	
	Если СтрокаДерева.КоличествоПредупреждений > 0 Тогда
		СтрокаДерева.ТекстПредупреждения = СтрокаДерева.ТекстПредупреждения + Символы.ПС;
	КонецЕсли;
	
	СтрокаДерева.ТекстПредупреждения = СтрокаДерева.ТекстПредупреждения + ТекстСообщения;
	СтрокаДерева.КоличествоПредупреждений = СтрокаДерева.КоличествоПредупреждений + 1;
	
КонецПроцедуры	

&НаКлиенте
Процедура РазвернутьСтруктураЗапроса()
	
	Для Каждого СтрокаПакет Из СтуктураЗапроса.ПолучитьЭлементы() Цикл
		
		Элементы.СтуктураЗапроса.Развернуть(СтрокаПакет.ПолучитьИдентификатор());
		
		Для Каждого СтрокаОператор Из СтрокаПакет.ПолучитьЭлементы() Цикл
			
			Элементы.СтуктураЗапроса.Развернуть(СтрокаОператор.ПолучитьИдентификатор());
			
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры
 
&НаСервере
Процедура ПоказатьИндексы(ИмяТаблицы)
	
	Если Найти(ИмяТаблицы,".") = 0 Тогда // Это вложенный запрос или временная таблица. TODO запоминать это при заполнении дерева, для временных таблиц можно запоминать индексы.
		Возврат
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(ИмяТаблицы);
	
	СтруктураХранения = ПолучитьСтруктуруХраненияБазыДанных(Массив);
	
	Индексы = СтруктураХранения.НайтиСтроки(Новый Структура("ИмяТаблицы",ИмяТаблицы))[0].Индексы;
	
	Для Каждого Индекс Из Индексы Цикл
		
		СтрокаИндекса = ДеревоИндексов.ПолучитьЭлементы().Добавить();
		СтрокаИндекса.ИмяИндексаХранения = Индекс.ИмяИндексаХранения; 
		
		Для Каждого Поле Из Индекс.Поля Цикл
			ЗаполнитьЗначенияСвойств(СтрокаИндекса.ПолучитьЭлементы().Добавить(),Поле);	
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация 
RegExp = Новый COMОбъект("VBScript.RegExp");

Условия = Новый Массив;
Условия.Добавить(">");
Условия.Добавить("<");
Условия.Добавить("<>");
Условия.Добавить("=");
Условия.Добавить(">=");
Условия.Добавить("<=");
Условия.Добавить("ПОДОБНО");
#КонецОбласти
