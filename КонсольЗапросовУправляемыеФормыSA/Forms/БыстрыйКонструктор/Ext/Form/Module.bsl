﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БК = БиблиотекаКартинок;
	
	Корень = Новый Массив;
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "Справочник", Метаданные.Справочники, БК.Справочник));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "Документ", Метаданные.Документы, БК.Документ));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "РегистрСведений", Метаданные.РегистрыСведений, БК.РегистрСведений));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "РегистрНакопления", Метаданные.РегистрыНакопления, БК.РегистрНакопления));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "РегистрБухгалтерии", Метаданные.РегистрыБухгалтерии, БК.РегистрБухгалтерии));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "РегистрРасчета", Метаданные.РегистрыРасчета, БК.РегистрРасчета));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "БизнесПроцесс", Метаданные.БизнесПроцессы, БК.БизнесПроцесс));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "Задача", Метаданные.Задачи, БК.Задача));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "ПланОбмена", Метаданные.ПланыОбмена, БК.ПланОбмена));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "ПланВидовХарактеристик", Метаданные.ПланыВидовХарактеристик, БК.ПланВидовХарактеристик));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "ПланВидовРасчета", Метаданные.ПланыВидовРасчета, БК.ПланВидовРасчета));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "ПланСчетов", Метаданные.ПланыСчетов, БК.ПланСчетов));
	Корень.Добавить(Новый Структура("Имя, Коллекция, Картинака", "Константа", Метаданные.Константы, БК.Константа));
	
	ЭлементыДерева = ДеревоМетаданных.ПолучитьЭлементы();
	
	Для Каждого УзелКорня Из Корень Цикл
		
		СтрокаКорня = ЭлементыДерева.Добавить();
		СтрокаКорня.УзелКорняМетаданных = УзелКорня.Имя;
		СтрокаКорня.Картинака = УзелКорня.Картинака;
		
		Для Каждого ОбъектМетаданных Из УзелКорня.Коллекция Цикл
			
			ПолноеИмяОбъектаМетаданных = УзелКорня.Имя+ "."
				+ ОбъектМетаданных.Имя;
	
			СтрокаОбъекта = СтрокаКорня.ОбъектыМетаданных.Добавить();
			СтрокаОбъекта.ОбъектМетаданных = ОбъектМетаданных.Имя;
			СтрокаОбъекта.ИсточникДанных = ОбъектМетаданных.Имя;
			СтрокаОбъекта.ПолноеИмяОбъектаМетаданных = ПолноеИмяОбъектаМетаданных;
							
			Если УзелКорня.Имя = "Константа"
				Или Найти(УзелКорня.Имя, "Регистр") = 1 Тогда
				Продолжить;
			КонецЕсли;
			
			Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
				
				СтрокаОбъекта = СтрокаКорня.ОбъектыМетаданных.Добавить();
				СтрокаОбъекта.ОбъектМетаданных = ОбъектМетаданных.Имя;
				СтрокаОбъекта.ТабличнаяЧасть = ТабличнаяЧасть.Имя;
				СтрокаОбъекта.ИсточникДанных = ОбъектМетаданных.Имя + "." + ТабличнаяЧасть.Имя;
			    СтрокаОбъекта.ПолноеИмяОбъектаМетаданных = ПолноеИмяОбъектаМетаданных;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если ЭлементыДерева[0].ОбъектыМетаданных.Количество() > 0 Тогда
		// Выведем поля для первого объекта. Остальные будут подгружаться динамически при выборе объекта.
		ДополнитьПоляОбъектаМетаданных(ЭлементыДерева[0], ЭлементыДерева[0].ОбъектыМетаданных[0]);
	КонецЕсли;
	
	ТекущийЭлемент = Элементы.ДеревоМетаданныхОбъектыМетаданныхСтрокаПоиска;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДеревоМетаданныхПриАктивизацииСтроки(Элемент)
	
	ПриАктивизацииСтрокиОбъектаМетаданных();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетаданныхОбъектыМетаданныхПриАктивизацииСтроки(Элемент)
	
	ПриАктивизацииСтрокиОбъектаМетаданных();
			
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетаданныхОбъектыМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СформироватьТекстЗапросаИЗакрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоМетаданныхОбъектыМетаданныхПоляОбъектаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля = Новый Массив;
	Поля.Добавить(Элементы.ДеревоМетаданныхОбъектыМетаданныхПоляОбъекта.ТекущиеДанные.Поле);
	
	СформироватьТекстЗапросаИЗакрыть(Поля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	
	СформироватьТекстЗапросаИЗакрыть(Неопределено);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенные(Команда)

	Поля = Новый Массив;
	
	ТекущаяСтрокаУзла = Элементы.ДеревоМетаданных.ТекущаяСтрока;
	ТекущиеОбъекты = ДеревоМетаданных.НайтиПоИдентификатору(ТекущаяСтрокаУзла).ОбъектыМетаданных;
	
	ТекущаяСтрокаОбъекта = Элементы.ДеревоМетаданныхОбъектыМетаданных.ТекущаяСтрока;
	ТекущиеПоля = ТекущиеОбъекты.НайтиПоИдентификатору(ТекущаяСтрокаОбъекта).ПоляОбъекта;
		
	Для Каждого ТекущаяСтрока Из Элементы.ДеревоМетаданныхОбъектыМетаданныхПоляОбъекта.ВыделенныеСтроки Цикл
		
		Поля.Добавить(ТекущиеПоля.НайтиПоИдентификатору(ТекущаяСтрока).Поле);
		
	КонецЦикла;

	СформироватьТекстЗапросаИЗакрыть(Поля);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ДополнитьПоляОбъектаМетаданных(ТекущийУзел, СтрокаТаблицыОбъектов)
	                
	Если ТекущийУзел.УзелКорняМетаданных = "Константа" Тогда
		Возврат
	КонецЕсли;
			
	Реквизиты = РеквизитыОбъектаМетаданных(СтрокаТаблицыОбъектов.ПолноеИмяОбъектаМетаданных
		, СтрокаТаблицыОбъектов.ТабличнаяЧасть);
	
	Для Каждого Реквизит Из Реквизиты Цикл
		
		НоваяСтрока = СтрокаТаблицыОбъектов.ПоляОбъекта.Добавить();
		НоваяСтрока.Поле = Реквизит;
		
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриАктивизацииСтрокиОбъектаМетаданных()
	
	ТекущиеДанные = Элементы.ДеревоМетаданныхОбъектыМетаданных.ТекущиеДанные;
	ТекущийУзел = Элементы.ДеревоМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Если ТекущиеДанные.ПоляОбъекта.Количество() = 0 Тогда
		ДополнитьПоляОбъектаМетаданных(ТекущийУзел, ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыОбъектаМетаданных(ПолноеИмяОбъектаМетаданных, ТабличнаяЧасть = "")
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	Реквизиты = Новый Массив;
	
	Если ЗначениеЗаполнено(ТабличнаяЧасть) Тогда
		Для Каждого Реквизит Из ОбъектМетаданных.ТабличныеЧасти[ТабличнаяЧасть].Реквизиты Цикл
			Реквизиты.Добавить(Реквизит.Имя);	
		КонецЦикла;
		Возврат Реквизиты;
	КонецЕсли;
	
	Для Каждого Реквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		Реквизиты.Добавить(Реквизит.Имя);	
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл				
		Реквизиты.Добавить(Реквизит.Имя);
	КонецЦикла; 
	
	Возврат Реквизиты;
	
КонецФункции

&НаКлиенте
Процедура СформироватьТекстЗапросаИЗакрыть(Поля)
	
	Узел = Элементы.ДеревоМетаданных.ТекущиеДанные;
	СтрокаОбъекта = Элементы.ДеревоМетаданныхОбъектыМетаданных.ТекущиеДанные;
		
	ТекстЗапроса = СформироватьТекстЗапроса(Узел.УзелКорняМетаданных
		, СтрокаОбъекта.ОбъектМетаданных
		, СтрокаОбъекта.ТабличнаяЧасть
		, Поля);
	
	Закрыть(ТекстЗапроса);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТекстЗапроса(УзелКорняМетаданных, ОбъектМетаданных, ТабличнаяЧасть, Поля)
	
	ИсточникДанных = ?(ТабличнаяЧасть = "", ОбъектМетаданных, ТабличнаяЧасть);
	ПолныйПуть = ?(ТабличнаяЧасть = "", УзелКорняМетаданных + "." + ОбъектМетаданных
		, УзелКорняМетаданных + "." + ОбъектМетаданных + "." + ТабличнаяЧасть);
	
	ТекстЗапроса = "ВЫБРАТЬ";
	
	Если Не ПустаяСтрока(ОграничениеВыборки) Тогда
		ТекстЗапроса = ТекстЗапроса + " " + ОграничениеВыборки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Поля) Тогда
		
		Для Каждого Поле Из Поля Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + "	" + ИсточникДанных + "." + Поле + ",";
		КонецЦикла;
		
		ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 1); // Удаление последней запятой.
		
	Иначе
		
		ТекстЗапроса = ТекстЗапроса + Символы.ПС + "	*";
		
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "ИЗ";
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + "	" + ПолныйПуть + " КАК " + ИсточникДанных;
	
	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти
