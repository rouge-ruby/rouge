module Rouge
  module Lexers
    class Bsl
      KEYWORDS = Set.new %w(
        КонецПроцедуры   EndProcedure   КонецФункции  EndFunction
        Прервать         Break          Продолжить    Continue
        Возврат          Return         Если          If
        Иначе            Else           ИначеЕсли     ElsIf
        Тогда            Then           КонецЕсли     EndIf
        Попытка          Try            Исключение    Except
        КонецПопытки     EndTry         Raise         ВызватьИсключение
        Пока             While          Для           For
        Каждого          Each           Из            In
        По               To             Цикл          Do
        КонецЦикла       EndDo          НЕ            NOT
        И                AND            ИЛИ           OR
        Новый            New            Процедура     Procedure
        Функция          Function       Перем         Var
        Экспорт          Export         Знач          Val
      )

      BUILTINS = Set.new %w(
        Лев Цел Окр Год Час Тип Мин Прав Сред ВРег НРег ТРег День Дата НСтр
        Макс Если Ложь СокрЛ СокрП Месяц Число Найти Иначе Тогда СокрЛП
        Символ Минута ТипЗнч Булево Строка Вопрос Сигнал Формат Задачи
        Отчеты Истина Секунда СтрДлина СтрНайти КонецДня ДеньГода Сообщить
        НачалоДня КонецГода КонецЧаса Состояние СтрШаблон Вычислить Документы
        Константы Обработки ИначеЕсли КонецЕсли КодСимвола НачалоГода
        НачалоЧаса НеделяГода ДеньНедели Оповестить ВвестиДату НайтиФайлы
        Метаданные СтрЗаменить СтрСравнить КонецМесяца КонецМинуты КонецНедели
        ТекущаяДата ВвестиЧисло ТекущийЯзык ЧасовойПояс ПланыОбмена ПланыСчетов
        Справочники РабочаяДата ПустаяСтрока СтрРазделить СтрСоединить
        НачалоМесяца НачалоМинуты НачалоНедели ОткрытьФорму АктивноеОкно
        ВвестиСтроку ПравоДоступа РольДоступна УдалитьФайлы ПолучитьФайл
        ПолучитьОкна МестноеВремя Перечисления ГлавныйСтиль Неопределено
        СтрЧислоСтрок КонецКвартала ДобавитьМесяц ПолучитьФорму ЧислоПрописью
        ИмяКомпьютера ЗначениеВФайл РазделитьФайл ПоместитьФайл ПолучитьФайлы
        ВнешниеОтчеты СредстваПочты СтрНачинаетсяС НачалоКвартала ПоказатьВопрос
        Предупреждение ОткрытьСправку ЗакрытьСправку ВвестиЗначение
        КомандаСистемы ПользователиОС КопироватьФайл СоздатьКаталог
        ПоместитьФайлы НайтиПоСсылкам УдалитьОбъекты ОписаниеОшибки
        БизнесПроцессы КритерииОтбора ФоновыеЗадания ОткрытьЗначение
        ИмяПользователя ЗначениеИзФайла ПереместитьФайл ОбъединитьФайлы
        БезопасныйРежим ПараметрыСеанса РегистрыРасчета ПараметрЗапуска
        ПоказатьЗначение ПоказатьВводДаты КаталогПрограммы ПараметрыДоступа
        ЗапуститьСистему НачатьТранзакцию МонопольныйРежим КодироватьСтроку
        БиблиотекаСтилей ВнешниеОбработки РегистрыСведений ГлавныйИнтерфейс
        СтрПолучитьСтроку СтрЧислоВхождений ОчиститьСообщения ПоказатьВводЧисла
        ЧасовойПоясСеанса ТекущаяДатаСеанса КаталогДокументов НачатьПоискФайлов
        ТранзакцияАктивна ОбновитьИнтерфейс ЗначениеЗаполнено ЖурналыДокументов
        ПланыВидовРасчета СредстваТелефонии ХранилищаНастроек СтрЗаканчиваетсяНа
        ПоказатьВводСтроки ПолучитьОбщийМакет ПолучитьОбщуюФорму
        ТекущийЯзыкСистемы ПредставлениеПрава ОтменитьТранзакцию
        ИнформацияОбОшибке УниверсальноеВремя БиблиотекаКартинок
        Последовательности РегистрыНакопления ТекущийРежимЗапуска
        ЗапуститьПриложение РаскодироватьСтроку ПолнотекстовыйПоиск
        РегистрыБухгалтерии РегламентныеЗадания СредстваМультимедиа
        ОткрытьИндексСправки ОткрытьФормуМодально ПоказатьВводЗначения
        ПредставлениеПериода ЗначениеВСтрокуВнутр НачатьПомещениеФайла
        НачатьУдалениеФайлов КонфигурацияИзменена ПолучитьДанныеВыбора
        ЗначениеВДанныеФормы ДанныеФормыВЗначение СредстваКриптографии
        ОповеститьОбИзменении ПолноеИмяПользователя ТекущийКодЛокализации
        ЗначениеИзСтрокиВнутр ПолучитьМаскуВсеФайлы НачатьПолучениеФайлов
        НачатьПомещениеФайлов КопироватьДанныеФормы ПоказатьПредупреждение
        ЗавершитьРаботуСистемы КаталогВременныхФайлов НачатьЗапускПриложения
        НачатьСозданиеКаталога НачатьКопированиеФайла НачатьПеремещениеФайла
        ПривилегированныйРежим СмещениеЛетнегоВремени ПриНачалеРаботыСистемы
        ВнешниеИсточникиДанных РасширенияКонфигурации ХранилищеОбщихНастроек
        ПрекратитьРаботуСистемы ПредставлениеПриложения ПолучитьРазделительПути
        ЗафиксироватьТранзакцию ДоставляемыеУведомления ПланыВидовХарактеристик
        ОткрытьСодержаниеСправки ПредопределенноеЗначение ПолучитьЗаголовокСистемы
        ЗаписьЖурналаРегистрации ЗаполнитьЗначенияСвойств ТекущаяУниверсальнаяДата
        ОбработкаВнешнегоСобытия ИспользованиеРабочейДаты ОбновитьНумерациюОбъектов
        ПолучитьБлокировкуСеансов УстановитьБезопасныйРежим
        НайтиПомеченныеНаУдаление ОчиститьЖурналРегистрации
        ПередНачаломРаботыСистемы УстановкаПараметровСеанса
        ИсторияРаботыПользователя ХранилищеВариантовОтчетов
        ПоказатьИнформациюОбОшибке КраткоеПредставлениеОшибки
        УстановитьЗаголовокСистемы ПолучитьИмяВременногоФайла
        УстановитьМонопольныйРежим ВыгрузитьЖурналРегистрации
        ПредставлениеЧасовогоПояса ПриЗавершенииРаботыСистемы
        ХранилищеСистемныхНастроек ОтключитьОбработчикОжидания
        УстановитьЧасовойПоясСеанса ПодключитьВнешнююКомпоненту
        УстановитьВнешнююКомпоненту ЭтоАдресВременногоХранилища
        УстановитьБлокировкуСеансов ПолучитьФункциональнуюОпцию
        ПолучитьНавигационнуюСсылку СмещениеСтандартногоВремени
        СредстваГеопозиционирования ХранилищеНастроекДанныхФорм
        ПодробноеПредставлениеОшибки ВыполнитьОбработкуОповещения
        ПодключитьОбработчикОжидания ВыполнитьПроверкуПравДоступа
        УдалитьИзВременногоХранилища ПолучитьМаскуВсеФайлыКлиента
        ПолучитьМаскуВсеФайлыСервера СкопироватьЖурналРегистрации
        ПерейтиПоНавигационнойСсылке ПредставлениеКодаЛокализации
        ПриИзмененииПараметровЭкрана ОтключитьОбработчикОповещения
        ПолучитьСообщенияПользователю ПолучитьИзВременногоХранилища
        ПоместитьВоВременноеХранилище НомерСеансаИнформационнойБазы
        ПередЗавершениемРаботыСистемы ПоказатьОповещениеПользователя
        ПодключитьОбработчикОповещения ПолучитьРазделительПутиКлиента
        ПолучитьРазделительПутиСервера НайтиОкноПоНавигационнойСсылке
        ПолучитьДопустимыеЧасовыеПояса ПользователиИнформационнойБазы
        ОбработкаПрерыванияПользователя ЗаблокироватьРаботуПользователя
        ЗапроситьРазрешениеПользователя УдалитьДанныеИнформационнойБазы
        БезопасныйРежимРазделенияДанных ОтправкаДоставляемыхУведомлений
        РабочийКаталогДанныхПользователя ПолучитьИнформациюЭкрановКлиента
        НачатьУстановкуВнешнейКомпоненты КодЛокализацииИнформационнойБазы
        УстановитьПривилегированныйРежим ПолучитьСеансыИнформационнойБазы
        ПолучитьИмяКлиентаЛицензирования НачатьПолучениеКаталогаДокументов
        ПолучитьОперативнуюОтметкуВремени НомерСоединенияИнформационнойБазы
        НеобходимостьЗавершенияСоединения ПолучитьИдентификаторКонфигурации
        ПолучитьСоответствиеОбъектаИФормы ПолучитьДопустимыеКодыЛокализации
        СтрокаСоединенияИнформационнойБазы ПолучитьКраткийЗаголовокПриложения
        НачатьПодключениеВнешнейКомпоненты ПодключитьРасширениеРаботыСФайлами
        УстановитьРасширениеРаботыСФайлами НачатьЗапросРазрешенияПользователя
        ПолучитьСтруктуруХраненияБазыДанных УстановитьСоответствиеОбъектаИФормы
        УстановитьКраткийЗаголовокПриложения ПолучитьСоединенияИнформационнойБазы
        ЗаблокироватьДанныеДляРедактирования ОбновитьПовторноИспользуемыеЗначения
        ПолучитьВремяЗавершенияСпящегоСеанса ПолучитьСкоростьКлиентскогоСоединения
        ПолучитьВремяОжиданияБлокировкиДанных РазблокироватьДанныеДляРедактирования
        ПолучитьЧасовойПоясИнформационнойБазы ПолучитьФункциональнуюОпциюИнтерфейса
        ПолучитьЗаголовокКлиентскогоПриложения
        НачатьПолучениеКаталогаВременныхФайлов
        ИнициализироватьПредопределенныеДанные
        ПолучитьВремяЗасыпанияПассивногоСеанса
        УстановитьВремяЗавершенияСпящегоСеанса
        ПолучитьТекущийСеансИнформационнойБазы
        ПредставлениеСобытияЖурналаРегистрации
        ТекущаяУниверсальнаяДатаВМиллисекундах
        НачатьУстановкуРасширенияРаботыСФайлами
        УстановитьВремяОжиданияБлокировкиДанных
        УстановитьЧасовойПоясИнформационнойБазы
        ПолучитьИспользованиеЖурналаРегистрации
        УстановитьЗаголовокКлиентскогоПриложения
        ПолучитьОбновлениеКонфигурацииБазыДанных
        УстановитьВремяЗасыпанияПассивногоСеанса
        УстановитьНастройкиКлиентаЛицензирования
        ПолучитьЗначенияОтбораЖурналаРегистрации
        УстановитьРасширениеРаботыСКриптографией
        ПодключитьРасширениеРаботыСКриптографией
        ПолучитьПредставленияНавигационныхСсылок
        ХранилищеПользовательскихНастроекОтчетов
        НачатьПодключениеРасширенияРаботыСФайлами
        КонфигурацияБазыДанныхИзмененаДинамически
        УстановитьБезопасныйРежимРазделенияДанных
        УстановитьИспользованиеЖурналаРегистрации
        ПолучитьПолноеИмяПредопределенногоЗначения
        РазорватьСоединениеСВнешнимИсточникомДанных
        БиблиотекаМакетовОформленияКомпоновкиДанных
        ПолучитьМинимальнуюДлинуПаролейПользователей
        УстановитьСоединениеСВнешнимИсточникомДанных
        ТекущийВариантИнтерфейсаКлиентскогоПриложения
        ПолучитьПроверкуСложностиПаролейПользователей
        НачатьУстановкуРасширенияРаботыСКриптографией
        ПолучитьНавигационнуюСсылкуИнформационнойБазы
        УстановитьМинимальнуюДлинуПаролейПользователей
        ПолучитьИспользованиеСобытияЖурналаРегистрации
        ПолучитьПараметрыФункциональныхОпцийИнтерфейса
        УстановитьПроверкуСложностиПаролейПользователей
        НачатьПодключениеРасширенияРаботыСКриптографией
        УстановитьИспользованиеСобытияЖурналаРегистрации
        УстановитьПараметрыФункциональныхОпцийИнтерфейса
        НачатьПолучениеРабочегоКаталогаДанныхПользователя
        ТекущийВариантОсновногоШрифтаКлиентскогоПриложения
        ПолучитьДополнительныйПараметрКлиентаЛицензирования
        ХранилищеПользовательскихНастроекДинамическихСписков
        ОтключитьОбработчикЗапросаНастроекКлиентаЛицензирования
        ПодключитьОбработчикЗапросаНастроекКлиентаЛицензирования
        ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы
        УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы
        AccessParameters AccessRight AccountingRegisters AccumulationRegisters
        ACos ACos ActiveWindow AddMonth ApplicationPresentation ASin ASin
        ATan ATan AttachAddIn AttachCryptoExtension AttachFileSystemExtension
        AttachIdleHandler AttachLicensingClientParametersRequestHandler
        AttachNotificationHandler BackgroundJobs Base64Строка Base64Значение
        Base64String Base64Value Beep BeforeExit BeforeStart BeginAttachingAddIn
        BeginAttachingCryptoExtension BeginAttachingFileSystemExtension
        BeginCopyingFile BeginCreatingDirectory BeginDeletingFiles
        BeginFindingFiles BeginGettingDocumentsDir BeginGettingFiles
        BeginGettingTempFilesDir BeginGettingUserDataWorkDir BeginInstallAddIn
        BeginInstallCryptoExtension BeginInstallFileSystemExtension
        BeginMovingFile BeginPutFile BeginPuttingFiles
        BeginRequestingUserPermission BeginRunningApplication BeginTransaction
        BegOfDay BegOfHour BegOfMinute BegOfMonth BegOfQuarter BegOfWeek
        BegOfYear BinDir Boolean BriefErrorDescription BusinessProcesses
        CalculationRegisters CanReadXML Catalogs Char CharCode ChartsOfAccounts
        ChartsOfCalculationTypes ChartsOfCharacteristicTypes ClearEventLog
        ClearMessages ClientApplicationBaseFontCurrentVariant
        ClientApplicationInterfaceCurrentVariant CloseHelp ПолучитьCOMОбъект
        CommitTransaction CommonSettingsStorage ComputerName ConfigurationChanged
        ConfigurationExtensions ConnectExternalDataSource ConnectionStopRequest
        Constants CopyEventLog CopyFormData Cos Cos CreateDirectory
        CreateXDTOFactory CryptoToolsManager CurrentDate CurrentLanguage
        CurrentLocaleCode CurrentRunMode CurrentSessionDate CurrentSystemLanguage
        CurrentUniversalDate CurrentUniversalDateInMilliseconds
        DataBaseConfigurationChangedDynamically
        DataCompositionAppearanceTemplateLib DataProcessors DataSeparationSafeMode
        Date Day DaylightTimeOffset DayOfYear DecodeString DeleteFiles
        DeleteFromTempStorage DeleteObjects DeliverableNotifications
        DeliverableNotificationSend DetachIdleHandler
        DetachLicensingClientParametersRequestHandler DetachNotificationHandler
        DetailErrorDescription DisconnectExternalDataSource DocumentJournals
        Documents DocumentsDir DoMessageBox DoQueryBox
        DynamicListsUserSettingsStorage Else ElsIf EncodeString EndIf
        EndOfDay EndOfHour EndOfMinute EndOfMonth EndOfQuarter EndOfWeek
        EndOfYear Enums EraseInfoBaseData ErrorDescription ErrorInfo Eval
        EventLogEventPresentation ExchangePlans ExclusiveMode
        ExecuteNotifyProcessing Exit Exp Exp ExternalDataProcessors
        ExternalDataSources ExternalReports ExternEventProcessing False
        FileCopy FillPropertyValues FilterCriteria Find FindByRef
        FindDisallowedXMLCharacters FindFiles FindMarkedForDeletion
        FindWindowByURL Format FormDataSettingsStorage FormDataToValue
        FromXMLType FullTextSearch GetAllFilesMask GetAvailableLocaleCodes
        GetAvailableTimeZones GetCaption GetChoiceData GetClientAllFilesMask
        GetClientApplicationCaption GetClientConnectionSpeed
        GetClientDisplaysInformation GetClientPathSeparator GetCommonForm
        GetCommonTemplate GetCOMObject GetConfigurationID GetCurrentInfoBaseSession
        GetDataBaseConfigurationUpdate GetDBStorageStructureInfo
        GetEventLogEventUse GetEventLogFilterValues GetEventLogUsing GetFile
        GetFiles GetForm GetFromTempStorage GetFunctionalOption
        GetHibernateSessionTerminateTime GetInfoBaseConnections
        GetInfoBasePredefinedData GetInfoBaseSessions GetInfoBaseTimeZone
        GetInfoBaseURL GetInterfaceFunctionalOption
        GetInterfaceFunctionalOptionParameters
        GetLicensingClientAdditionalParameter GetLicensingClientName
        GetLockWaitTime GetObjectAndFormConformity GetPassiveSessionHibernateTime
        GetPathSeparator GetPredefinedValueFullName GetRealTimeTimestamp
        GetServerAllFilesMask GetServerPathSeparator GetSessionsLock
        GetShortApplicationCaption GetStandardODataInterfaceContent
        GetTempFileName GetURL GetURLsPresentations GetUserMessages
        GetUserPasswordMinLength GetUserPasswordStrengthCheck GetWindows
        GetXMLType GotoURL Hour If ImportXDTOModel InfoBaseConnectionNumber
        InfoBaseConnectionString InfoBaseLocaleCode InfoBaseSessionNumber
        InfoBaseUsers InformationRegisters InitializePredefinedData InputDate
        InputNumber InputString InputValue InstallAddIn InstallCryptoExtension
        InstallFileSystemExtension Int IsBlankString IsInRole IsTempStorageURL
        ЗаписатьJSON ПрочитатьJSON ЗаписатьДатуJSON ПрочитатьДатуJSON
        LaunchParameter Left LocaleCodePresentation LocationTools LockApplication
        LockDataForEdit Log Log Log10 Log10 Lower MailTools MainInterface
        MainStyle Max MergeFiles Message Metadata Mid Min Minute Month
        MoveFile MultimediaTools Notify NotifyChanged NStr NULL Number
        NumberInWords ПолучитьСоставСтандартногоИнтерфейсаOData
        УстановитьСоставСтандартногоИнтерфейсаOData OnChangeDisplaySettings
        OnExit OnStart OpenForm OpenFormModal OpenHelp OpenHelpContent
        OpenHelpIndex OpenValue OSUsers PeriodPresentation PictureLib Pow
        Pow PredefinedValue PrivilegedMode PutFile PutFiles PutToTempStorage
        ReadJSON ReadJSONDate ReadXML RefreshInterface RefreshObjectsNumbering
        RefreshReusableValues Reports ReportsUserSettingsStorage
        ReportsVariantsStorage RequestUserPermission Right RightPresentation
        RollbackTransaction Round RunApp RunSystem SafeMode ScheduledJobs
        Second Sequences SessionParameters SessionParametersSetting
        SessionTimeZone SetCaption SetClientApplicationCaption
        SetDataSeparationSafeMode SetEventLogEventUse SetEventLogUsing
        SetExclusiveMode SetHibernateSessionTerminateTime
        SetInfoBasePredefinedDataUpdate SetInfoBaseTimeZone
        SetInterfaceFunctionalOptionParameters SetLicensingClientParameters
        SetLockWaitTime SetObjectAndFormConformity SetPassiveSessionHibernateTime
        SetPrivilegedMode SetSafeMode SetSessionsLock SetSessionTimeZone
        SetShortApplicationCaption SetStandardODataInterfaceContent
        SettingsStorages SetUserPasswordMinLength SetUserPasswordStrengthCheck
        ShowErrorInfo ShowInputDate ShowInputNumber ShowInputString
        ShowInputValue ShowMessageBox ShowQueryBox ShowUserNotification
        ShowValue Sin Sin SplitFile Sqrt Sqrt StandardTimeOffset Status
        StrCompare StrConcat StrEndsWith StrFind StrGetLine String StrLen
        StrLineCount StrOccurrenceCount StrReplace StrSplit StrStartWith
        StrTemplate StyleLib System SystemSettingsStorage Tan Tan Tasks
        TelephonyTools TempFilesDir Terminate Then TimeZone TimeZonePresentation
        Title ToLocalTime ToUniversalTime TransactionActive TrimAll TrimL
        TrimR True Type TypeOf Undefined UnloadEventLog UnlockDataForEdit
        Upper UserDataWorkDir UserFullName UserInterruptProcessing UserName
        UserWorkHistory ValueFromFile ValueFromStringInternal ValueIsFilled
        ValueToFile ValueToFormData ValueToStringInternal VerifyAccessRights
        WeekDay WeekOfYear WorkingDate WorkingDateUse WriteJSON WriteJSONDate
        WriteLogEvent WriteXML WSСсылки WSReferences ФабрикаXDTO ИмпортМоделиXDTO
        СериализаторXDTO СоздатьФабрикуXDTO XDTOFactory XDTOSerializer
        XMLТип XMLСтрока XMLТипЗнч ИзXMLТипа XMLЗначение ЗаписатьXML
        ПрочитатьXML ПолучитьXMLТип ВозможностьЧтенияXML
        НайтиНедопустимыеСимволыXML XMLString XMLType XMLTypeOf XMLValue
        Year
      )
    end
  end
end
