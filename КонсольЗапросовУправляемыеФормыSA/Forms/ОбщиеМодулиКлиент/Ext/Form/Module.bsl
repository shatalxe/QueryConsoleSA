﻿&НаКлиенте
Процедура ДобавитьУбратьСимволыВНачалоТекстовогоДокумента(Элемент, НаборСимволов, РежимУдаления = Ложь) Экспорт
	
	Перем СтрНач, СтрКон, КолНач, КолКон;
	
	ДлинаСтроки = СтрДлина(НаборСимволов);
	Смещение = ?(РежимУдаления, 0, ДлинаСтроки);

	Элемент.ПолучитьГраницыВыделения(СтрНач, КолНач, СтрКон, КолКон);
	Элемент.УстановитьГраницыВыделения(СтрНач, 1, СтрКон, КолКон); // Установим на начало строки
	
	ВыделенныйТекст = Элемент.ВыделенныйТекст;
	
	// Если курсор стоит за границами текста, то предыдущие действия добавляют новый перенос
	Если Прав(Элемент.ВыделенныйТекст, 1) = Символы.ПС Тогда
		ВыделенныйТекст = Лев(Элемент.ВыделенныйТекст, СтрДлина(Элемент.ВыделенныйТекст)-1);
	КонецЕсли;
		
	ДобавитьУбратьСимволыВНачалоСтроки(ВыделенныйТекст, НаборСимволов, РежимУдаления, Смещение);
	Элемент.ВыделенныйТекст = ВыделенныйТекст;
	Элемент.УстановитьГраницыВыделения(СтрНач, Макс(1,КолНач+Смещение), СтрКон, Макс(1,КолКон+Смещение));
	  
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьУбратьСимволыВНачалоСтроки(Строка, НаборСимволов, РежимУдаления = Ложь, Смещение = 0) Экспорт
	
	ЧислоСимволов = СтрДлина(НаборСимволов);		
	МассивСтрок = Вычислить("СтрРазделить(Строка, Символы.ПС)");
	
	Для Сч = 0 По МассивСтрок.Количество()-1 Цикл
		
		СтрокаИтог = МассивСтрок[Сч];
		
		Если РежимУдаления Тогда
			
			Если Вычислить("СтрНачинаетсяС(СтрокаИтог, НаборСимволов)") Тогда
				СтрокаИтог = Сред(СтрокаИтог,ЧислоСимволов+1);
			ИначеЕсли Вычислить("СтрНачинаетсяС(СокрЛ(СтрокаИтог), НаборСимволов)") Тогда
				// Найдем первое вхождение и удалим
				Попытка
					ПозицияНабора = Вычислить("СтрНайти(СтрокаИтог, НаборСимволов)");
				Исключение
					ПозицияНабора = Найти(СтрокаИтог,НаборСимволов);	
				КонецПопытки;
				СтрокаИтог = Лев(СтрокаИтог,ПозицияНабора-1)+Сред(СтрокаИтог,ПозицияНабора+1);	
			КонецЕсли;
			
			// Если изменилась последняя строка, то сместим её
			Если Сч = МассивСтрок.Количество() - 1 Тогда 
				Смещение = -ЧислоСимволов;
			КонецЕсли;
								
		Иначе		
			СтрокаИтог = НаборСимволов + МассивСтрок[Сч];
		КонецЕсли;
		
		МассивСтрок[Сч] = СтрокаИтог;
		
	КонецЦикла;
	
	Строка = Вычислить("СтрСоединить(МассивСтрок, Символы.ПС)"); 
  
КонецПроцедуры
