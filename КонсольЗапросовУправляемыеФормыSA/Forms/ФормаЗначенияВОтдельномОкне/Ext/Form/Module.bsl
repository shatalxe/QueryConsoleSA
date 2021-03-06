﻿#Область ОписаниеПеременных
&НаКлиенте
Перем ОсновнаяФорма;
&НаКлиенте
Перем КонсольОбщиеМодулиКлиент;
&НаКлиенте
Перем ЗаретРазворачиванияУзлаДерева; // Защита от бесконечного цикла из-за сочетания клавиш ctrl shift + 
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НаКлиенте = Истина;

	Параметры.Свойство("Выражение", Выражение);	
	НаКлиенте = ?(Параметры.Свойство("НаКлиенте"), Параметры.НаКлиенте, Истина);	
	Параметры.Свойство("АдресХранилищаЗначений", АдресХранилищаЗначенийВладельца);	
	Параметры.Свойство("АдресРезультатаВыполнения", АдресРезультатаВыполненияВладельца);
	Параметры.Свойство("ИдентификаторЗначения", ИдентификаторЗначения);
	
	АдресХранилищаЗначений = ПоместитьВоВременноеХранилище(Новый Соответствие, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОсновнаяФорма = ПолучитьФорму(ИмяОбработки() + ".Форма");	
		
	ВычислитьВыражение();
		
КонецПроцедуры

&НаКлиенте
Процедура ВыражениеПриИзменении(Элемент)	
	ВычислитьВыражение();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы
&НаКлиенте
Процедура Подключаемый_ВыборРезультата(Элемент)
	
	ОсновнаяФорма.ВыборРезультата(ЭтаФорма, Элемент);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриАктивизацииСтроки(Элемент)
	
	ОсновнаяФорма.ПриАктивизацииСтроки(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПередРазворачиванием(Элемент, Строка, Отказ)
	
	Если ЗаретРазворачиванияУзлаДерева = Истина Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("РазрешитьРазвернутьСтрокуРезультата", 0.1, Истина);
		Возврат
	КонецЕсли;

	РезультатПередРазворачиваниемНаСервере(Элемент.Имя, Строка, Отказ);
	
	ЗаретРазворачиванияУзлаДерева = Истина;	
	ПодключитьОбработчикОжидания("РазрешитьРазвернутьСтрокуРезультата", 0.1, Истина);

КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРазвернутьСтрокуРезультата() Экспорт
	
	ЗаретРазворачиванияУзлаДерева = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура РезультатПередРазворачиваниемНаСервере(ИмяДерева, Строка, Отказ)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ВыводЗначенийСвойствРазвернутьЗначениеДерева(ЭтаФорма, ЭтаФорма[ИмяДерева], Строка, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ПоказатьЗначениеВОтдельномОкне(Команда)
		
	ОсновнаяФорма.ПоказатьЗначениеВОтдельномОкне(ЭтаФорма, Команда, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборРезультатаКоманда(Команда)
	
	ОсновнаяФорма.ПоказатьЗначениеВОтдельномОкне(ЭтаФорма, Команда, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыражение(Команда)
	ВычислитьВыражение();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьНовоеЗначение(Команда)
	
	ТекущиеДанные = ЭтаФорма.Элементы.ГруппаРезультат.ПодчиненныеЭлементы[0].ТекущиеДанные;
	ИдентификаторЗначения = ТекущиеДанные.ПолучитьРодителя().Значение;
	СсылкаНаИзменяемыйОбъект = ОсновнаяФорма.ПолучитьЗначениеИзВременногоХранилищаНаСервере(
		АдресХранилищаЗначений,
		ИдентификаторЗначения);	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Свойство", ТекущиеДанные.Свойство);
	ПараметрыФормы.Вставить("СсылкаНаИзменяемыйОбъект", СсылкаНаИзменяемыйОбъект);
	
	Оповещение = Новый ОписаниеОповещения("Подключаемый_УстановитьНовоеЗначениеЗавершение", ЭтаФорма);
	ОткрытьФорму(ИмяОбработки() + ".Форма.ВводВыражения" 
		,ПараметрыФормы
		,ЭтаФорма,,,
		,Оповещение
		,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьНовоеЗначениеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат
	КонецЕсли;
	
	ТекущиеДанные = ЭтаФорма.Элементы.ГруппаРезультат.ПодчиненныеЭлементы[0].ТекущиеДанные;
	ТекущиеДанные.ЗначениеПредставление = Строка(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КодДляЗаполненияОбъекта(Команда)
	
	ТекущиеДанные = ЭтаФорма.Элементы.ГруппаРезультат.ПодчиненныеЭлементы[0].ТекущиеДанные;
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	ОписаниеДата = Новый ОписаниеТипов("Дата");
	ОписаниеЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 5));
	Результат = "";
	
	Для Каждого ТекущаяСтрока Из ТекущиеДанные.ПолучитьЭлементы() Цикл
		
		Если Не ЗначениеЗаполнено(ТекущаяСтрока.ЗначениеПредставление) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекущаяСтрока.Свойство = "Ссылка"
			Или ТекущаяСтрока.Свойство = "УникальныйИдентификатор"
			Или ТекущаяСтрока.Свойство = "ВерсияДанных" 
			Или Лев(ТекущаяСтрока.Свойство, 7) = "Удалить" Тогда
			Продолжить;
		КонецЕсли;
		
		Если Лев(ТекущаяСтрока.Тип, 12) = "Перечисление" Тогда			
			
			Значение = ОсновнаяФорма.ПолучитьЗначениеИзВременногоХранилищаНаСервере(
					АдресХранилищаЗначений,
					ТекущаяСтрока.Значение
					, Истина);			
			ЗначениеПредставление = СтрЗаменить(ТекущаяСтрока.Тип, "Перечисление.", "Перечисления.") + "." + Значение;
			
		ИначеЕсли Лев(ТекущаяСтрока.Тип, 10) = "Справочник" Тогда	
			Значение = ТекущаяСтрока.ЗначениеПредставление;
		 	ЗначениеПредставление = СтрЗаменить(ТекущаяСтрока.Тип, "Справочник", "Справочники") + ".НайтиПоНаименованию("
				+ """" + ТекущаяСтрока.ЗначениеПредставление + """" + ")";
		ИначеЕсли ТекущаяСтрока.Тип = "Булево" Тогда
			// Значение приведем к типу Число, чтобы Ложь (0) считать пустым значением. 
			Значение = ОписаниеЧисло.ПривестиЗначение(ОписаниеБулево.ПривестиЗначение(ТекущаяСтрока.ЗначениеПредставление));
			ЗначениеПредставление = Формат(ОписаниеБулево.ПривестиЗначение(ТекущаяСтрока.ЗначениеПредставление), "БЛ=Ложь; БИ=Истина"); 
		ИначеЕсли Лев(ТекущаяСтрока.Тип, 6) = "Строка" Тогда
			Значение = ТекущаяСтрока.ЗначениеПредставление;
			ЗначениеПредставление = """" + ТекущаяСтрока.ЗначениеПредставление + """";
		ИначеЕсли Лев(ТекущаяСтрока.Тип, 4) = "Дата" Тогда
			Значение = ОписаниеДата.ПривестиЗначение(ТекущаяСтрока.ЗначениеПредставление);
			ЗначениеПредставление = "Дата(" + """" + ТекущаяСтрока.ЗначениеПредставление + """" + ")";
		ИначеЕсли Лев(ТекущаяСтрока.Тип, 5) = "Число" Тогда
			Значение = ОписаниеЧисло.ПривестиЗначение(ТекущаяСтрока.ЗначениеПредставление);
			ЗначениеПредставление = ТекущаяСтрока.ЗначениеПредставление;
		Иначе				
			Значение = ТекущаяСтрока.ЗначениеПредставление;	
			ЗначениеПредставление = ТекущаяСтрока.ЗначениеПредставление;
		КонецЕсли;	
		
		Если Не ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;

		Результат = Результат + "ЗаполняемыйОбъект." + ТекущаяСтрока.Свойство + " = " 
			+ ЗначениеПредставление + ";" + Символы.ПС;
						
	КонецЦикла;
	
	ПоказатьВводСтроки(Новый ОписаниеОповещения("Подключаемый_КодДляЗаполненияОбъектаЗавершение", ЭтотОбъект), Результат,,, Истина);
			
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КодДляЗаполненияОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ВывестиРезультат()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Если Не ЭтоАдресВременногоХранилища(АдресРезультатаВыполнения) Тогда
		Возврат
	КонецЕсли;
	
	Значение = ПолучитьИзВременногоХранилища(АдресРезультатаВыполнения);
	
	МассивЗначений = ОбработкаОбъект.ЗначениеВТаблицуЗначений(Значение);  
	ОбработкаОбъект.ДобавитьМассивЗначенийНаФому(ЭтаФорма, Элементы.ГруппаРезультат, МассивЗначений, Элементы.ДекорацияНетДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ВычислитьВыражение()
	
	Если НаКлиенте Тогда
		ВычислитьВыражениеНаКлиенте();
	Иначе
		ВычислитьВыражениеНаСервере();	
	КонецЕсли;
	
	Элементы.Выражение.СписокВыбора.Добавить(Выражение);

КонецПроцедуры

&НаКлиенте
Процедура ВычислитьВыражениеНаКлиенте()
	
	Попытка
		
		Значение = Вычислить(Выражение);			
		ПередатьЗначениеНаСерверИВывести(Значение);
		
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьВыражениеНаСервере()
		
	Попытка
		
		Значение = Вычислить(Выражение);			
		АдресРезультатаВыполнения = ПоместитьВоВременноеХранилище(Значение);
		ВывестиРезультат();
		
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
				
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьЗначениеНаСерверИВывести(Значение);
	
	Если ТипЗнч(Значение) = Тип("ДанныеФормыЭлементКоллекции")
		Или ТипЗнч(Значение) = Тип("ДанныеФормыЭлементДерева") Тогда
		
		МассивЧастей = Вычислить("СтрРазделить(Выражение,"".["")");
		ВыражениеРодителя = МассивЧастей[0]+"."+МассивЧастей[1];
		Родитель = Вычислить(ВыражениеРодителя);
		
		ПоместитьСтрокуВСтруктуруИВывести(Родитель, Значение.ПолучитьИдентификатор());
		
	ИначеЕсли ТипЗнч(Значение) = Тип("ДанныеФормыКоллекция")
		Или ТипЗнч(Значение) = Тип("ДанныеФормыДерево") Тогда
		
	  	ДанныеФормыВЗначениеИВывести(Значение);
		
	Иначе
		
		ПоместитьВХранилищеИВывести(Значение);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ДанныеФормыВЗначениеИВывести(Значение)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	Данные = ОбработкаОбъект.ДанныеФормыВЗначениеБезТипа(Значение);
	ПоместитьВХранилищеИВывести(Данные);
	
КонецФункции

&НаСервере
Функция ПоместитьВХранилищеИВывести(Значение)
	
	АдресРезультатаВыполнения = ПоместитьВоВременноеХранилище(Значение);
	ВывестиРезультат();
	
КонецФункции

&НаСервере
Функция ПоместитьСтрокуВСтруктуруИВывести(Таблица, ИдентификаторСтроки)
	
	Значение = ПолучитьСтруктуруСтроки(Таблица, ИдентификаторСтроки);
	ПоместитьВХранилищеИВывести(Значение);
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруСтроки(Таблица, ИдентификаторСтроки)
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	СтруктураВозврата = Новый Структура;
	Колонки = ОбработкаОбъект.ДанныеФормыВЗначениеБезТипа(Таблица).Колонки;
	Строка = Таблица.НайтиПоИдентификатору(ИдентификаторСтроки);
	ХранилищеЗначений = ПолучитьИзВременногоХранилища(АдресХранилищаЗначенийВладельца);
	
	Для Сч = 0 По Колонки.Количество() - 1 Цикл
		
		Колонка = Колонки[Сч];
		
		Если Сч < Колонки.Количество() - 1 Тогда
			
			// Неотображаемые значения, по которым было выведено представление, обратно получим и вернем в структуре.
			СледующаяКолонка = Колонки[Сч + 1];
			
			Если СтрЗаканчиваетсяНа(Колонка.Имя, "Представление")
				И Колонка.Имя = СледующаяКолонка.Имя + "Представление" 
				И ТипЗнч(Строка[СледующаяКолонка.Имя]) = Тип("УникальныйИдентификатор") Тогда
				// Значит это неотображаемое значение, помещенное в хранилище.
				Значение = ХранилищеЗначений.Получить(Строка[СледующаяКолонка.Имя]);
				СтруктураВозврата.Вставить(СледующаяКолонка.Имя, Значение);
				Сч = Сч + 1;
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		СтруктураВозврата.Вставить(Колонка.Имя, Строка[Колонка.Имя]);
		
	КонецЦикла;

	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Функция ИмяОбработки() Экспорт
	
	Позиция1 = Найти(ИмяФормы, ".");
	Позиция2 = Найти(Сред(ИмяФормы, Позиция1 + 1), ".");
	
	Возврат Лев(ИмяФормы, Позиция1 + Позиция2 - 1); 
	
КонецФункции

#КонецОбласти
