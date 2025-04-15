CREATE TABLE americanfamily.dcm_afi_log_data.test AS
(
    select max(event_time) as event_time
    from `americanfamily.dcm_afi_log_data.activity_1642420`
);
-- Gather Impression, Click and Activity data for Digital, Social and Search
CREATE TABLE americanfamily.dcm_afi_log_data.jan_feb_logs AS
(
select *
from
(
select timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, null as Activity_ID, State_Region, 
City_ID, U_Value, null as Segment_Value_1, Active_View_Eligible_Impressions, Active_View_Measurable_Impressions, Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
from `americanfamily.dcm_afi_log_data.impression_1642420`
where Site_ID_DCM in 
('7250811', '7194285', '7269068', '7268147', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7549941', '7255470', '7268771',	'7268765', '7250805', '7265524', '7709286', '7295447', '7304852', '7268756', '7268762', '7250799')

UNION ALL 

select 
timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, null as Activity_ID, State_Region, 
City_ID, U_Value, Segment_Value_1, null as Active_View_Eligible_Impressions, null as Active_View_Measurable_Impressions, null as Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
from `americanfamily.dcm_afi_log_data.click_1642420`
where Site_ID_DCM in ('7250811', '7194285', '7269068', '7268147', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7549941', '7255470', '7268771',	'7268765', '7250805', '7265524', '7709286', '7295447', '7304852', '7268756', '7268762', '7250799')

UNION ALL

select 
timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, Activity_ID, State_Region, 
null as City_ID, U_Value, Segment_Value_1, null as Active_View_Eligible_Impressions, null as Active_View_Measurable_Impressions, null as Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
from `americanfamily.dcm_afi_log_data.activity_1642420`
where Site_ID_DCM in ('7250811', '7194285', '7269068', '7268147', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7549941', '7255470', '7268771',	'7268765', '7250805', '7265524', '7709286', '7295447', '7304852', '7268756', '7268762', '7250799')
and Activity_ID in ('11752107', '11701682', '11705624', '11707436', '11734123', '11735659', '11699270', '11707433', '11704262', '11701925', '11734117', '11849090', '11875936', '11876527', '11873521', '11702501')
)
where Event_Date >= '2022-01-01' and Event_Date <= '2022-02-28'
)

-- Select substring of Paid_Search_Keyword_ID to get it to a length that matches Segment_Value_1 so we can join the data later
CREATE TABLE americanfamily.dcm_afi_log_data.parsed_keyword_ids AS
(
select substring(cast(Paid_Search_Keyword_ID as string), 7, 11) as Paid_Search_Keyword_ID, Paid_Search_Keyword
from americanfamily.dcm_afi_log_data.p_match_table_paid_search_1642420
where Paid_Search_Keyword_ID is not null
)

-- Create a mapping table with segment value, keyword id keyword and brand or nonbrand that we can use to join keywords to segment_value_1
CREATE TABLE americanfamily.dcm_afi_log_data.segmentvalue_keyword_mapping AS
(
select distinct l.Segment_Value_1, ps.Paid_Search_Keyword_ID, ps.Paid_Search_Keyword,
case when ps.Paid_Search_Keyword like '%america%'
or ps.Paid_Search_Keyword like '%amfam%'
or ps.Paid_Search_Keyword like '%am fam%' then 'Brand' else 'Nonbrand' end as Brand_Nonbrand
from americanfamily.dcm_afi_log_data.jan_feb_logs l 
left join americanfamily.dcm_afi_log_data.parsed_keyword_ids ps on l.Segment_Value_1 = ps.Paid_Search_Keyword_ID
where ps.Paid_Search_Keyword_ID is not null
)

-- Map out the Site Name, Channel, Stage Of Funnel of each row by using Site IDs and Placement ID (for APEX data)

CREATE TABLE americanfamily.dcm_afi_log_data.placement_categorical_details AS 
(
select distinct Site_ID_DCM, Placement_ID, 
case when Placement_ID in ('315128799', '315443774') then 'Search'
when Site_ID_DCM in ('7268756', '7268762', '7250799') then 'Social'
when Placement_ID in ('316509634', '317016021', '316691183', '316691498', '316691669', '316714425', '319706333', '319746594', '319750194', '319934140', '320193272', '320411341', '316509919',
'325299338', '325299347', '324424429', '324424624', '323458257', '323458449', '323458458', '323458710', '323239994', '325759178', '325760687', '325298141', '325301096', '325535509', '325535512',
'325214549', '325215620', '325276842', '325276848', '325276851', '325276854', '325276857', '325459951', '325459957', '325459963', '325459966', '325460542') then 'Audio'
when Placement_ID in ('319704454', '317042197', '320112652', '319475093', '319479776', '323388503', '323605375', '323458275', '323389265', '324596544',
'324789964', '323420780', '323445201', '323446398', '323389235', '323458437', '325265798', '325312146', '325312149', '324571958', '324596550', '324774157', '324789973', '324790276',
'324790282', '324619421', '324619439', '319919382', '323387612', '323387621', '324840259', '324209831', '324219915', '324025412', '325656431',
'325656434', '324840247', '325765181', '325800084', '325977466', '315346809', '324614535', '324614541', '324614640', '324615048', '325765175', '316304354',
'317042206', '316846787', '317063551', '317063392', '317063554', '316847084', '316843349') then 'Video'
when Placement_ID in ('316843349', '316847084', '317042197', '320112652', '323605375', '317063551', '324774157', '324790282', '319919382', '325656431', '325656434', '325765181', '325800084', '325977466', '324614535', '324614541', '324614640', '324615048', '325765175') then 'CTV' else 'Display' end as Channel,
case when Placement_ID in ('316905058',	'317063551',	'328993176',	'329135869',	'316714425',	'325276857',	'325737319',	'326231111',	'324619421',	
'328976969',	'328976816',	'318456628',	'325520160',	'325459966',	'323387612',	'328977296',	'328977473',	'328976813',	'325547595',	'325301096',	
'325737316',	'325215620',	'316847084',	'324619439',	'325765175',	'325800084',	'328977290',	'325312149',	'325265798',	'326231360',	'316691498',	
'319750194',	'319706333',	'325708276',	'328976951',	'328977488',	'324840247',	'316846787',	'317041297',	'325736005',	'324614541',	'325459951',	
'317063554',	'325459957',	'317063392',	'318456892',	'323389265',	'328977476',	'328976819',	'324614535',	'316867481',	'325977466',	'325276854',	
'316691669',	'319436051',	'323388503',	'324615048',	'325759178',	'319663030',	'317042197',	'325312146',	'325535512',	'318254667',	'316691183',	
'319479801',	'325214549',	'318257370',	'320411341',	'323387621',	'325760687',	'328977305',	'328976807',	'328993170',	'325299338',	'325500233',	
'325460542',	'325276851',	'325459963',	'319746594',	'323389235',	'325520163',	'325656434',	'325765181',	'325299347',	'329135650',	'317042206',	
'318711066',	'326231351',	'325276848',	'319934140',	'318257361',	'323605375',	'324840259',	'329135866',	'328977326',	'328976828',	'321578424',	
'325535509',	'325276842',	'328977320',	'316905109',	'328977323',	'316691687',	'325298141',	'326262015',	'316843349',	'320193272',	'325656431',	
'316903843',	'329135860',	'315346809',	'324614640') then 'Awareness'
when Placement_ID in ('324654265',	'324025412',	'324654193',	'323458458',	'324790282',	'324453138',	'327193409',	'325737965',	'323457918',	'325949938',	'315660523',	'315663601',
'324596550',	'323469181',	'328986745',	'323239997',	'324454482',	'319714634',	'319919382',	'325898436',	'315493947',	'315663598',	'324424624',	'325122689',	'324219915',
'323458710',	'325524069',	'323458437',	'328054024',	'324653437',	'329005297',	'324654334',	'324455331',	'316509919',	'324789973',	'319554944',	'324445571',	'324474636',
'324453135',	'328055506',	'327116372',	'324479492',	'324445643',	'324637819',	'316509634',	'325738469',	'325521807',	'324654196',	'324445031',	'327233064',	'324445028',
'325865072',	'325358551',	'323458713',	'319789798',	'315663625',	'328863612',	'329433815',	'325554637',	'325781823',	'324445808',	'324445022',	'324637231',	'324445562',
'325661691',	'324653443',	'324445640',	'324653449',	'317717834',	'329012563',	'328053340',	'324790276',	'324455328',	'327298645',	'327193847',	'324445574',	'324453144',
'319753080',	'324454596',	'324596544',	'328806587',	'325865063',	'324571958',	'324789964',	'323458461',	'323458275',	'323278098',	'324454590',	'324479501',	'325448248',
'325708291',	'316633036',	'324653440',	'323239994',	'324424429',	'325708282',	'324654256',	'328863996',	'328841873',	'329436212',	'315495060',	'324424426',	'324445577',
'324209831',	'316630585',	'323458707',	'327116570',	'324454527',	'324454533',	'324451800',	'324654199',	'324454341',	'325898472',	'324425161',	'315661711',	'319975624',
'325263777',	'324653446',	'324451719',	'327233046',	'324445124',	'324445094',	'315513473',	'319939729',	'325959487',	'325120061',	'323239118',	'325775265',	'324454536',
'316633021',	'323240498',	'325471184',	'324444971',	'324445040',	'320112652',	'328862850',	'317016021',	'316304354',	'329003422',	'328056589',	'317682795',	'324444839',
'323458449',	'323458257',	'326067100',	'324451773',	'324774157',	'324445115',	'327397266',	'325782252',	'328842749',	'315513452',	'324444980',	'315663604',	'315513461') then 'Consideration'
when Placement_ID in ('323431584',	'323438360',	'323624311',	'324454443',	'325425144',	'324451686',	'317042221',	'323470387',	'324454551',	'323437772',	'323429709',
'323625289',	'316847636',	'315495165',	'324654166',	'323430828',	'324654106',	'323431296',	'323437040',	'323430810',	'323405813',	'324444908',	'323624338',	
'315515624',	'315495174',	'324454221',	'324453087',	'323437652',	'327673936',	'323405801',	'323413800',	'323431356',	'324454431',	'324455310',	'315941625',	
'315945047',	'325777965',	'315495162',	'316112386',	'316112362',	'315944885',	'325207751',	'315663751',	'325451857',	'315941541',	'315515033',	'315944858',	
'315941643',	'315942489',	'315493743',	'316112398',	'319566260',	'325748063',	'315660520',	'315493740',	'315663634',	'315660463',	'325799655',	'325786881',	
'319801045',	'315513428',	'325797852',	'326066045',	'323405786',	'323437643',	'323435426',	'323405789',	'315128799',	'323458500',	'323405966',	'323458746',	
'323430855',	'323458464',	'315443774',	'323435444',	'323437031',	'323430801',	'323471263',	'323457936',	'325414179',	'323225726',	'323458539',	'324453111',	
'323406098',	'324654292',	'323431284',	'325778229',	'323457939',	'323431317',	'315663412',	'323431293',	'315941517',	'315945944',	'315944876',	'325738655',	
'325265721',	'315495441',	'315494130',	'315945017',	'315663769',	'315941622',	'315937647',	'319800748',	'325964413',	'315663616',	'315941676',	'315942504',	
'315661693',	'315661702',	'315663640',	'315660541',	'325748618',	'315942501',	'319800766',	'315493713',	'325122179',	'319801030',	'315513425',	'319800772',	
'323387552',	'324444869',	'324454422',	'324454293',	'324454506',	'323435453',	'323437028',	'324455283',	'323470654',	'324454455',	'323431617',	'324454467',	
'324444992',	'323435432',	'316845827',	'323458773',	'323458767',	'323405018',	'323406110',	'323279571',	'324451701',	'315941589',	'325267542',	'323430867',	
'324444788',	'323429721',	'326067511',	'324454566',	'323470672',	'325547098',	'323458743',	'315944693',	'315944852',	'323458488',	'315941592',	'315945032',	
'323406116',	'323437820',	'323458737',	'324445007',	'325448902',	'315663745',	'325778307',	'315941634',	'315941616',	'315515057',	'315515042',	'315495141',	
'325738898',	'315515612',	'315495444',	'325776621',	'315937641',	'325738538',	'315945029',	'319556900',	'315515072',	'315495432',	'315493710',	'319801036',	
'315944918',	'315513467',	'315493722',	'315493650',	'319566671',	'323226896',	'324654235',	'324444989',	'323429733',	'323431326',	'323430864',	'324454203',	
'324654367',	'323437760',	'324445547',	'323430843',	'324444890',	'324445013',	'323406131',	'323437811',	'317042224',	'324444860',	'323246433',	'323435411',	
'323457951',	'324454236',	'324453078',	'323624290',	'325739075',	'323458722',	'325747859',	'323403254',	'323405768',	'323413803',	'323458758',	'324445610',	
'323429745',	'315494106',	'315494103',	'315488562',	'315945077',	'315663739',	'315663442',	'325738550',	'325865993',	'326071990',	'315660472',	'326068340',	
'326071328',	'326092959',	'325784454',	'315663619',	'323603830',	'323406128',	'323457978',	'323437826',	'324445049',	'323624350',	'323437646',	'324453120',	
'323431338',	'324451743',	'323458509',	'323623477',	'323405753',	'324654373',	'323458728',	'323223695',	'323246430',	'323405756',	'323280144',	'323450488',	
'323470399',	'323429760',	'323435423',	'315495420',	'325265214',	'315494109',	'319801795',	'315515606',	'324451677',	'325267500',	'315944897',	'315945929',	
'315663391',	'315945059',	'325955065',	'325955116',	'315941586',	'315944714',	'316114084',	'327537408',	'315944867',	'316112428',	'319800763',	'315944705',	
'315660484',	'325183257',	'315513470',	'315945956',	'315493962',	'319607940',	'315513446',	'315660862',	'325959517',	'323431611',	'323430819',	'323429712',	
'323437829',	'323458467',	'324654133',	'324454548',	'323435429',	'323458752',	'324454521',	'323437817',	'323458470',	'324444884',	'323405045',	'323431350',	
'324453099',	'323437655',	'316843364',	'323623459',	'323458494',	'315663766',	'323406119',	'323624314',	'325265508',	'323430861',	'323458521',	'323458761',	
'323605294',	'324445595',	'325775937',	'315495180',	'315494124',	'325522434',	'315945080',	'316112422',	'315941628',	'325742228',	'315663760',	'316114069',	
'319801792',	'319800742',	'325777839',	'315661654',	'327194360',	'315945023',	'325893756',	'327354470',	'319800754',	'323438363',	'323431620',	'323435435',	
'323458524',	'323625286',	'323458749',	'323437808',	'323458725',	'323437805',	'323438366',	'323430846',	'323437769',	'323246424',	'323457954',	'324653401',	
'323429757',	'325264158',	'323406092',	'323430834',	'323406134',	'323241008',	'323431593',	'323389250',	'323458497',	'315941637',	'315494121',	'323246427',	
'325396481',	'327544540',	'315494112',	'316112389',	'315941529',	'315944696',	'315495159',	'315944855',	'315515048',	'315944900',	'315941565',	'315945083',	
'327195251',	'315495186',	'315945038',	'315493677',	'315493737',	'316112374',	'315493914',	'327355109',	'316114087',	'319801051',	'315660469',	'325356984',	
'319558781',	'315495069',	'315662344',	'325959511',	'319800745',	'315660466',	'325365797',	'323430882',	'323431608',	'323405033',	'324654316',	'323437670',	
'323437766',	'323624305',	'325385318',	'323624323',	'323458491',	'323431320',	'324444815',	'323437790',	'324451755',	'323437049',	'323435441',	'323437034',	
'323403245',	'323435438',	'324444944',	'323457972',	'323406032',	'323437037',	'324454560',	'324445010',	'315944879',	'325955437',	'315495453',	'315663415',	
'325892379',	'325775943',	'315515576',	'315663775',	'315663781',	'315495447',	'316114063',	'315494094',	'315937671',	'315941631',	'315495456',	'325742168',	
'325775394',	'326089920',	'319566257',	'315513419',	'315493929',	'325797921',	'315660514',	'324454518',	'323429715',	'323457945',	'323430894',	'324451695',	
'323458506',	'323623465',	'324454569',	'323431287',	'324455292',	'323446398',	'323405027',	'323431599',	'323437634',	'323226893',	'325428996',	'324654280',	
'324445001',	'323431581',	'323435408',	'323624335',	'324454512',	'324453069',	'323471269',	'324654175',	'323437631',	'324454263',	'323435447',	'323438381',	
'323225723',	'315663742',	'315663772',	'315663736',	'315515069',	'315515579',	'325776384',	'315495183',	'319479776',	'315663409',	'315663748',	'325768305',	
'315941550',	'315515600',	'315645565',	'319475093',	'325207457',	'315944699',	'316112365',	'325207955',	'315937653',	'326938744',	'315493965',	'326737043',	
'325358722',	'315663289',	'315944894',	'319800760',	'325763603',	'325964521',	'315513464',	'325748345',	'325976881',	'315660529',	'315493968',	'326071163',	
'325786464',	'324453066',	'324445586',	'323437616',	'323430816',	'324445508',	'323445201',	'324653386',	'323437799',	'323438369',	'323438372',	'323437667',	
'323437775',	'323430831',	'325207874',	'324454545',	'323623453',	'323405798',	'315941520',	'316112350',	'315941532',	'323431341',	'324445085',	'315494115',	
'315941574',	'315493917',	'327194993',	'315515039',	'325629724',	'327383080',	'319704454',	'316114081',	'325738058',	'325520241',	'315663574',	'315942510',	
'325865174',	'315661699',	'315661696',	'315662365',	'315660502',	'325786203',	'315495072',	'315945926',	'319801786',	'325385750',	'324654355',	'324451662',	
'323405783',	'324454179',	'323430858',	'323625292',	'323279568',	'323406113',	'323280138',	'323624332',	'324654301',	'323405039',	'323406125',	'324451668',	
'323431569',	'323405996',	'323430849',	'323241002',	'323458278',	'323406089',	'324654154',	'323431572',	'324653407',	'323437661',	'315495438',	'324445511',	
'315937656',	'315515603',	'315941508',	'315515597',	'315495429',	'315945923',	'315495411',	'315941604',	'325264767',	'315663439',	'316112383',	'325777503',	
'315944891',	'316114090',	'315663286',	'315493647',	'325745552',	'325786494',	'315513422',	'326071166',	'323437043',	'325430316',	'323458512',	'323470657',	
'323246418',	'323437628',	'323458527',	'323420780',	'316847078',	'323437061',	'323624329',	'323226899',	'323279124',	'323470393',	'324653413',	'323280147',	
'325096613',	'325864682',	'327536994',	'325451698',	'315945917',	'323431335',	'327195296',	'315663385',	'325892259',	'315941502',	'315663430',	'325738067',	
'315663754',	'315937659',	'325739081',	'315941613',	'315495408',	'327537411',	'316112353',	'327543421',	'315515054',	'319801798',	'315493665',	'315663292',	
'315493959',	'319566677',	'315660517',	'319607925',	'315660544',	'325748789',	'325786884',	'315937638',	'315661666',	'319566266',	'315660493',	'325798425') then 'Conversion' else 'Unspecified' end as Stage_Of_Funnel,
case when Site_ID_DCM = '7295447' then 'Bing'
when Site_ID_DCM = '7304852' then 'Google'
when Site_ID_DCM = '7250811' then 'Quantcast'
when Site_ID_DCM = '7194285' then 'Yahoo'
when Site_ID_DCM = '7269068' then 'AdTheorent'
when Site_ID_DCM = '7268756' then 'Facebook'
when Site_ID_DCM = '7250817' then 'TedX'
when Site_ID_DCM = '7267595' then 'Vevo'
when Site_ID_DCM = '7265527' then 'Pandora'
when Site_ID_DCM = '7269065' then 'APEX-TTD'
when Site_ID_DCM = '7268153' then 'Youtube'
when Site_ID_DCM = '7268762' then 'Pinterest'
when Site_ID_DCM = '7265521' then 'Twitch'
when Site_ID_DCM = '7250799' then 'Snapchat'
when Site_ID_DCM = '7549941' then 'Yahoo'
when Site_ID_DCM = '7255470' then 'Home Team Sport'
when Site_ID_DCM = '7268771' then 'Waze'
when Site_ID_DCM = '7268765' then 'Roku'
when Site_ID_DCM = '7250805' then 'Hulu'
when Site_ID_DCM = '7265524' then 'ESPN'
when Site_ID_DCM = '7709286' then 'Media IQ'
when Placement_ID in ('316843349', '316843364',	'316845827', '316847078', '316847084', '316847636',	'317042221',	
'317042224', '324619439', '323413800', '323387552',	'323389250', '323603830', '323605294', '324840259',	'323413803') then 'APEX-Amazon'
when Placement_ID in ('325214549', '325215620', '325276842', '325276848', '325276851', '325276854', '325276857', '325459951', '325459957', '325459963', '325459966', '325460542', '316691687') then 'APEX-Audacy'
when Placement_ID in ('317042197', '323388503', '323458275', '323389265', '323458437') then 'APEX-Hulu'
when Placement_ID in ('325299338', '325299347',	'325759178', '325760687', '325298141', '325301096',	'325535509', '325535512') then 'APEX-Pandora'
when Placement_ID in ('324619421', '324840247', '316846787', '317042206') then 'APEX-Roku'
when Placement_ID in ('316509634', '317016021',	'316509919', '323457918', '323458461', '323458707', '323458713', '324424426', '324425161', '324424429', '324424624', '323458257', '323458449', 
'323458458', '323458710', '324209831', '324219915',	'323239994', '324025412', '316304354', '319714634', '316905109', '319753080', '319939729') then 'APEX-Spotify' 
when Placement_ID = '323389235' then 'APEX-Twitch' else 'Panic' end as Site_Name_Clean
from americanfamily.dcm_afi_log_data.jan_feb_logs
)

-- Join the categorically mapped data by placement to the unioned impression, click and activity table
CREATE TABLE americanfamily.dcm_afi_log_data.jan_feb_complete_logs AS
(
select l.*, p.Channel, p.Stage_Of_Funnel, p.Site_Name_Clean, ps.Brand_Nonbrand
from americanfamily.dcm_afi_log_data.jan_feb_logs l
left join americanfamily.dcm_afi_log_data.placement_categorical_details p on l.Placement_ID = p.Placement_ID
left join americanfamily.dcm_afi_log_data.segmentvalue_keyword_mapping ps on l.Segment_Value_1 = ps.Paid_Search_Keyword_ID
where l.User_ID != '0'
)

-- Select event_date, active view impressions, channels, stage of funnel and site names from the complete logs table and create flags for each event type
CREATE TABLE americanfamily.dcm_afi_log_data.jan_feb_master AS
(
select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
case when Event_Type = 'CLICK' then 1 else 0 end as Click,
case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
from americanfamily.dcm_afi_log_data.jan_feb_complete_logs
)

----------------------------------------------------------------------------------END OF CREATING THE MASTER LOG DATA TABLE-----------------------------------------------------------------------------

-- See what the average impression frequency for each publisher for Display
select Site_Name_Clean, sum(Impression) as Impression, count(distinct User_ID) as Total_Unique_Reach, sum(Impression) / count(distinct User_ID) as Avg_Impression_Frequency
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display'
group by Site_Name_Clean

-- See what the average impression frequency for each publisher at each stage of funnel for Display
select Site_Name_Clean, Stage_Of_Funnel, sum(Impression) as Impression, count(distinct User_ID) as Total_Unique_Reach, sum(Impression) / count(distinct User_ID) as Avg_Impression_Frequency
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display'
group by Site_Name_Clean, Stage_Of_Funnel

-- Group up individual users and all of their media interactions with Display media at the awareness SOF (change Channel, Stage_Of_Funnel and Site_Name_Clean as necessary to pull specific slices of data)
select Impression, count(distinct User_ID) as Total_Unique_Users, sum(Click) as Click, sum(Conversion) as Conversion, sum(Conversion)/count(distinct User_ID) as Conversion_Rate
from (
select User_ID, Site_Name_Clean, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display' and Stage_Of_Funnel = 'Conversion'
group by User_ID, Site_Name_Clean
)
where Site_Name_Clean = 'AdTheorent'
group by Impression
order by 1

-- See what was the max number of impressions a user got from one publisher broken out by stage of funnel
select Site_Name_Clean, Stage_Of_Funnel, max(Impression) as Impression_Max
from 
(
select User_ID, Site_Name_Clean, Stage_Of_Funnel, sum(Impression) as Impression
from americanfamily.dcm_afi_log_data.jan_feb_master
group by User_ID, Site_Name_Clean, Stage_Of_Funnel
)
group by Site_Name_Clean, Stage_Of_Funnel

-- See what the average impression frequency for each publisher for Audio
select Site_Name_Clean, sum(Impression) as Impression, count(distinct User_ID) as Total_Unique_Reach, sum(Impression) / count(distinct User_ID) as Avg_Impression_Frequency
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Audio'
group by Site_Name_Clean

-- See what the average impression frequency for each publisher at each stage of funnel for Audio
select Site_Name_Clean, Stage_Of_Funnel, sum(Impression) as Impression, count(distinct User_ID) as Total_Unique_Reach, sum(Impression) / count(distinct User_ID) as Avg_Impression_Frequency
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Audio'
group by Site_Name_Clean, Stage_Of_Funnel

-- Group up individual users and all of their media interactions with Audio media at the awareness SOF (change Channel, Stage_Of_Funnel and Site_Name_Clean as necessary to pull specific slices of data)
select Impression, count(distinct User_ID) as Total_Unique_Users, sum(Click) as Click, sum(Conversion) as Conversion, sum(Conversion)/count(distinct User_ID) as Conversion_Rate
from (
select User_ID, Site_Name_Clean, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Audio' and Stage_Of_Funnel = 'Awareness'
group by User_ID, Site_Name_Clean
)
where Site_Name_Clean = 'APEX-Pandora'
group by Impression
order by 1
--------------------------------------------------------------------------------END OF FREQUENCY ANALYSIS-----------------------------------------------------------------------------------------------

-- Seperate out Display and Awareness from the master log table
create table americanfamily.dcm_afi_log_data.jan_feb_display_awareness_overlap as
(
select *
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display' and Stage_Of_Funnel = 'Awareness'
)

-- Seperate out Display and Consideration from the master log table
create table americanfamily.dcm_afi_log_data.jan_feb_display_consideration_overlap as
(
select *
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display' and Stage_Of_Funnel = 'Consideration'
)

-- Seperate out Display and Conversion from the master log table
create table americanfamily.dcm_afi_log_data.jan_feb_display_conversion_overlap as
(
select *
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display' and Stage_Of_Funnel = 'Conversion'
)

-- Seperate out just Display in case there isn't much overlap for Awareness
create table americanfamily.dcm_afi_log_data.jan_feb_display_overlap as
(
select *
from americanfamily.dcm_afi_log_data.jan_feb_master
where Channel = 'Display'
)

-- Query for overlap by Site Names where Channel = Display and Stage Of Funnel = Awareness
select Media_IQ, Twitch, ESPN, TedX, Pandora, Youtube, APEX_TTD, APEX_Amazon, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression,
sum(Media_IQ_Impression) as Media_IQ_Impression, sum(Twitch_Impression) as Twitch_Impression, sum(ESPN_Impression) as ESPN_Impression, sum(TedX_Impression) as TedX_Impression, sum(Pandora_Impression) as Pandora_Impression, sum(Youtube_Impression) as Youtube_Impression,
sum(APEX_TTD_Impression) as APEX_TTD_Impression, sum(APEX_Amazon_Impression) as APEX_Amazon_Impression
from 
(
select case when Media_IQ > 0 then 1 else 0 end as Media_IQ,
case when Twitch > 0 then 1 else 0 end as Twitch,
case when ESPN > 0 then 1 else 0 end as ESPN,
case when TedX > 0 then 1 else 0 end as TedX,
case when Pandora > 0 then 1 else 0 end as Pandora,
case when Youtube > 0 then 1 else 0 end as Youtube,
case when APEX_TTD > 0 then 1 else 0 end as APEX_TTD,
case when APEX_Amazon > 0 then 1 else 0 end as APEX_Amazon, Unique_Users, Impression, Media_IQ_Impression, Twitch_Impression, ESPN_Impression, TedX_Impression, Pandora_Impression, Youtube_Impression, APEX_TTD_Impression, APEX_Amazon_Impression
from
(
select Media_IQ, Twitch, ESPN, TedX, Pandora, Youtube, APEX_TTD, APEX_Amazon, count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Media_IQ) as Media_IQ_Impression,
sum(Twitch) as Twitch_Impression, sum(ESPN) as ESPN_Impression, sum(TedX) as TedX_Impression, sum(Pandora) as Pandora_Impression, sum(Youtube) as Youtube_Impression, sum(APEX_TTD) as APEX_TTD_Impression,
sum(APEX_Amazon) as APEX_Amazon_Impression
from
(
select User_ID, sum(Impression) as Impression, countif(Media_IQ = 1) as Media_IQ, countif(Twitch = 1) as Twitch, countif(ESPN = 1) as ESPN,
countif(TedX = 1) as TedX, countif(Pandora = 1) as Pandora, countif(Youtube= 1) as Youtube, countif(APEX_TTD = 1) as APEX_TTD, countif(APEX_Amazon = 1) as APEX_Amazon
from
(
select User_ID, Impression,
case when Site_Name_Clean = 'Media IQ' and Impression = 1 then 1 else 0 end as Media_IQ,
case when Site_Name_Clean = 'Twitch' and Impression = 1 then 1 else 0 end as Twitch,
case when Site_Name_Clean = 'ESPN' and Impression = 1 then 1 else 0 end as ESPN,
case when Site_Name_Clean = 'TedX' and Impression = 1 then 1 else 0 end as TedX,
case when Site_Name_Clean = 'Pandora' and Impression = 1 then 1 else 0 end as Pandora,
case when Site_Name_Clean = 'Youtube' and Impression = 1 then 1 else 0 end as Youtube,
case when Site_Name_Clean = 'APEX-TTD' and Impression = 1 then 1 else 0 end as APEX_TTD,
case when Site_Name_Clean = 'APEX-Amazon' and Impression = 1 then 1 else 0 end as APEX_Amazon
from americanfamily.dcm_afi_log_data.jan_feb_display_awareness_overlap
)
group by User_ID
)
group by Media_IQ, Twitch, ESPN, TedX, Pandora, Youtube, APEX_TTD, APEX_Amazon
)
)
group by Media_IQ, Twitch, ESPN, TedX, Pandora, Youtube, APEX_TTD, APEX_Amazon

-- Query for overlap by Site Names where Channel = Display and Stage Of Funnel = Consideration
select APEX_Spotify, Waze, Yahoo, APEX_TTD, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression,
sum(APEX_Spotify_Impression) as APEX_Spotify_Impression, sum(Waze_Impression) as Waze_Impression, sum(Yahoo_Impression) as Yahoo_Impression, sum(APEX_TTD_Impression) as APEX_TTD_Impression
from 
(
select case when APEX_Spotify > 0 then 1 else 0 end as APEX_Spotify,
case when Waze > 0 then 1 else 0 end as Waze,
case when Yahoo > 0 then 1 else 0 end as Yahoo,
case when APEX_TTD > 0 then 1 else 0 end as APEX_TTD,
Unique_Users, Impression, APEX_Spotify_Impression, Waze_Impression, Yahoo_Impression, APEX_TTD_Impression
from
(
select APEX_Spotify, Waze, Yahoo, APEX_TTD, count(User_ID) as Unique_Users, sum(Impression) as Impression,
sum(APEX_Spotify) as APEX_Spotify_Impression, sum(Waze) as Waze_Impression, sum(Yahoo) as Yahoo_Impression, sum(APEX_TTD) as APEX_TTD_Impression
from
(
select User_ID, sum(Impression) as Impression, countif(APEX_Spotify = 1) as APEX_Spotify, countif(Waze = 1) as Waze, countif(Yahoo = 1) as Yahoo, countif(APEX_TTD = 1) as APEX_TTD
from
(
select User_ID, Impression,
case when Site_Name_Clean = 'APEX-Spotify' and Impression = 1 then 1 else 0 end as APEX_Spotify,
case when Site_Name_Clean = 'Waze' and Impression = 1 then 1 else 0 end as Waze,
case when Site_Name_Clean = 'Yahoo' and Impression = 1 then 1 else 0 end as Yahoo,
case when Site_Name_Clean = 'APEX-TTD' and Impression = 1 then 1 else 0 end as APEX_TTD
from americanfamily.dcm_afi_log_data.jan_feb_display_consideration_overlap
)
group by User_ID
)
group by APEX_Spotify, Waze, Yahoo, APEX_TTD
)
)
group by APEX_Spotify, Waze, Yahoo, APEX_TTD

-- Query for overlap by Site Names where Channel = Display
select Yahoo, APEX_Amazon, APEX_TTD, Quantcast, AdTheorent, ESPN, Youtube, Pandora, Media_IQ, APEX_Spotify, TedX, Waze, Twitch, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression,
sum(Yahoo_Impression) as Yahoo_Impression, sum(APEX_Amazon_Impression) as APEX_Amazon_Impression, sum(APEX_TTD_Impression) as APEX_TTD_Impression, sum(Quantcast_Impression) as Quantcast_Impression, sum(AdTheorent_Impression) as AdTheorent_Impression, sum(ESPN_Impression) as ESPN_Impression,
sum(Youtube_Impression) as Youtube_Impression, sum(Pandora_Impression) as Pandora_Impression, sum(Media_IQ_Impression) as Media_IQ_Impression, sum(APEX_Spotify_Impression) as APEX_Spotify_Impression, sum(TedX_Impression) as TedX_Impression, sum(Waze_Impression) as Waze_Impression,
sum(Twitch_Impression) as Twitch_Impression
from 
(
select case when Yahoo > 0 then 1 else 0 end as Yahoo,
case when APEX_Amazon > 0 then 1 else 0 end as APEX_Amazon,
case when APEX_TTD > 0 then 1 else 0 end as APEX_TTD,
case when Quantcast > 0 then 1 else 0 end as Quantcast,
case when AdTheorent > 0 then 1 else 0 end as AdTheorent,
case when ESPN > 0 then 1 else 0 end as ESPN,
case when Youtube > 0 then 1 else 0 end as Youtube,
case when Pandora > 0 then 1 else 0 end as Pandora, 
case when Media_IQ > 0 then 1 else 0 end as Media_IQ,
case when APEX_Spotify > 0 then 1 else 0 end as APEX_Spotify,
case when TedX > 0 then 1 else 0 end as TedX,
case when Waze > 0 then 1 else 0 end as Waze,
case when Twitch > 0 then 1 else 0 end as Twitch, 
Unique_Users, Impression, Yahoo_Impression, APEX_Amazon_Impression, APEX_TTD_Impression, Quantcast_Impression, AdTheorent_Impression, ESPN_Impression, Youtube_Impression, Pandora_Impression, Media_IQ_Impression, APEX_Spotify_Impression, TedX_Impression,
Waze_Impression, Twitch_Impression
from
(
select Yahoo, APEX_Amazon, APEX_TTD, Quantcast, AdTheorent, ESPN, Youtube, Pandora, Media_IQ, APEX_Spotify, TedX, Waze, Twitch, count(User_ID) as Unique_Users, sum(Impression) as Impression,
sum(Yahoo) as Yahoo_Impression, sum(APEX_Amazon) as APEX_Amazon_Impression, sum(APEX_TTD) as APEX_TTD_Impression, sum(Quantcast) as Quantcast_Impression, sum(AdTheorent) as AdTheorent_Impression, sum(ESPN) as ESPN_Impression,
sum(Youtube) as Youtube_Impression, sum(Pandora) as Pandora_Impression, sum(Media_IQ) as Media_IQ_Impression, sum(APEX_Spotify) as APEX_Spotify_Impression, sum(TedX) as TedX_Impression, sum(Waze) as Waze_Impression, sum(Twitch) as Twitch_Impression,
from
(
select User_ID, sum(Impression) as Impression, countif(Yahoo = 1) as Yahoo, countif(APEX_Amazon = 1) as APEX_Amazon, countif(APEX_TTD = 1) as APEX_TTD,
countif(Quantcast = 1) as Quantcast, countif(AdTheorent = 1) as AdTheorent, countif(ESPN = 1) as ESPN, countif(Youtube = 1) as Youtube, countif(Pandora = 1) as Pandora, countif(Media_IQ = 1) as Media_IQ, countif(APEX_Spotify = 1) as APEX_Spotify,
countif(TedX= 1) as TedX, countif(Waze = 1) as Waze, countif(Twitch = 1) as Twitch,
from
(
select User_ID, Impression,
case when Site_Name_Clean = 'Yahoo' and Impression = 1 then 1 else 0 end as Yahoo,
case when Site_Name_Clean = 'APEX-Amazon' and Impression = 1 then 1 else 0 end as APEX_Amazon,
case when Site_Name_Clean = 'APEX-TTD' and Impression = 1 then 1 else 0 end as APEX_TTD,
case when Site_Name_Clean = 'Quantcast' and Impression = 1 then 1 else 0 end as Quantcast,
case when Site_Name_Clean = 'AdTheorent' and Impression = 1 then 1 else 0 end as AdTheorent,
case when Site_Name_Clean = 'ESPN' and Impression = 1 then 1 else 0 end as ESPN,
case when Site_Name_Clean = 'Youtube' and Impression = 1 then 1 else 0 end as Youtube,
case when Site_Name_Clean = 'Pandora' and Impression = 1 then 1 else 0 end as Pandora,
case when Site_Name_Clean = 'Media IQ' and Impression = 1 then 1 else 0 end as Media_IQ,
case when Site_Name_Clean = 'APEX-Spotify' and Impression = 1 then 1 else 0 end as APEX_Spotify,
case when Site_Name_Clean = 'TedX' and Impression = 1 then 1 else 0 end as TedX,
case when Site_Name_Clean = 'Waze' and Impression = 1 then 1 else 0 end as Waze,
case when Site_Name_Clean = 'Twitch' and Impression = 1 then 1 else 0 end as Twitch
from americanfamily.dcm_afi_log_data.jan_feb_display_overlap
)
group by User_ID
)
group by Yahoo, APEX_Amazon, APEX_TTD, Quantcast, AdTheorent, ESPN, Youtube, Pandora, Media_IQ, APEX_Spotify, TedX, Waze, Twitch
)
)
group by Yahoo, APEX_Amazon, APEX_TTD, Quantcast, AdTheorent, ESPN, Youtube, Pandora, Media_IQ, APEX_Spotify, TedX, Waze, Twitch

