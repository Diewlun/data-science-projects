CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs AS
(
	select *
	from
	(
		select timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, null as Activity_ID, State_Region, 
		City_ID, U_Value, null as Segment_Value_1, Active_View_Eligible_Impressions, Active_View_Measurable_Impressions, Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
		from `americanfamily.dcm_afi_log_data.impression_1642420`
		where Site_ID_DCM in 
		('7295447', '7304852', '7250811', '7194285', '7269068', '7268147', '7268756', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7250799', '7549941', '7255470', '7268771', '7268765', '7250805', '7265524', '7709286', '7756700', '7805309', '7268759')

		UNION ALL 

		select 
		timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, null as Activity_ID, State_Region, 
		City_ID, U_Value, Segment_Value_1, null as Active_View_Eligible_Impressions, null as Active_View_Measurable_Impressions, null as Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
		from `americanfamily.dcm_afi_log_data.click_1642420`
		where Site_ID_DCM in ('7295447', '7304852', '7250811', '7194285', '7269068', '7268147', '7268756', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7250799', '7549941', '7255470', '7268771', '7268765', '7250805', '7265524', '7709286', '7756700', '7805309', '7268759')

		UNION ALL

		select 
		timestamp_micros(Event_Time) as Event_Date, User_ID, Advertiser_ID, Campaign_ID, Site_ID_DCM, Ad_ID, Placement_ID, Activity_ID, State_Region, 
		null as City_ID, U_Value, Segment_Value_1, null as Active_View_Eligible_Impressions, null as Active_View_Measurable_Impressions, null as Active_View_Viewable_Impressions, Event_Type, Event_Sub_Type
		from `americanfamily.dcm_afi_log_data.activity_1642420`
		where Site_ID_DCM in ('7295447', '7304852', '7250811', '7194285', '7269068', '7268147', '7268756', '7250817', '7267595', '7265527', '7269065', '7268153', '7268762', '7265521', '7250799', '7549941', '7255470', '7268771', '7268765', '7250805', '7265524', '7709286', '7756700', '7805309', '7268759')
		and Activity_ID in ('11856221', '11701682', '11705624', '11734123', '11735659', '11707433', '11734117', '11849090', '11875936', '12324854', '11917533', '11862365', '11860412', '11862443', '11925405')
		)
	where Event_Date >= '2022-01-01' and Event_Date <= '2022-03-31'
	)
	
-- Select substring of Paid_Search_Keyword_ID to get it to a length that matches Segment_Value_1 so we can join the data later
CREATE TABLE americanfamily.dcm_afi_log_data.parsed_keyword_ids AS
(
	select substring(cast(Paid_Search_Keyword_ID as string), 7, 11) as Paid_Search_Keyword_ID, Paid_Search_Keyword
	from americanfamily.dcm_afi_log_data.p_match_table_paid_search_1642420
	where Paid_Search_Keyword_ID is not null
	)
	
CREATE TABLE americanfamily.dcm_afi_log_data.segmentvalue_keyword_mapping AS
(
	select distinct k.*, p.Paid_Search_Campaign,
	case when p.Paid_Search_Campaign like '%AFPS%' then 'No Product'
	when p.Paid_Search_Campaign like '%NP%' then 'No Product'
	when p.Paid_Search_Campaign like '%AFAT%' then 'Auto'
	when p.Paid_Search_Campaign like '%Auto%' then 'Auto'
	when p.Paid_Search_Campaign like '%AFCM%' then 'Small Business'
	when p.Paid_Search_Campaign like '%Business%' then 'Small Business'
	when p.Paid_Search_Campaign like '%AFHM%' then 'Home'
	when p.Paid_Search_Campaign like '%Home%'then 'Home'
	when p.Paid_Search_Campaign like '%AFLF%' then 'Life'
	when p.Paid_Search_Campaign like '%Life%' then 'Life'
	when p.Paid_Search_Campaign like '%AFBN%' then 'Bundle'
	when p.Paid_Search_Campaign like '%AFRN%' then 'Renters'
	when p.Paid_Search_Campaign like '%AFFR%' then 'Secondary LOB'
	when p.Paid_Search_Campaign like '%AFHB%' then 'Secondary LOB' else 'Unspecified' end as Product
	from (
		select distinct l.Segment_Value_1, ps.Paid_Search_Keyword_ID, ps.Paid_Search_Keyword,
		case when ps.Paid_Search_Keyword like '%america%'
		or ps.Paid_Search_Keyword like '%amfam%'
		or ps.Paid_Search_Keyword like '%am fam%' then 'Brand' else 'Nonbrand' end as Brand_Nonbrand
		from americanfamily.dcm_afi_log_data.jan_march_logs l 
		left join americanfamily.dcm_afi_log_data.parsed_keyword_ids ps on l.Segment_Value_1 = ps.Paid_Search_Keyword_ID
		where ps.Paid_Search_Keyword_ID is not null) k
	left join americanfamily.dcm_afi_log_data.p_match_table_paid_search_1642420 p on k.Paid_Search_Keyword_ID = p.Paid_Search_Legacy_Keyword_ID
	)

--Create categorical mapping table (saved as a separate file because of the ugly syntax)

-- Query to check the percentage of user match for each publisher
select Site_Name_Clean, Channel, Product, sum(case when User_ID != '0' then 1 else 0 end) / count(User_ID) as User_ID_Match_Rate
from (
    select l.*, p.Channel, p.Stage_Of_Funnel, p.Site_Name_Clean, ps.Brand_Nonbrand,
    case when p.Product = 'Unspecified' and l.Campaign_ID = '26535238' then ps.Product else p.Product end as Product
    from americanfamily.dcm_afi_log_data.jan_march_logs l
    left join americanfamily.dcm_afi_log_data.placement_categorical_details p on l.Placement_ID = p.Placement_ID
    left join americanfamily.dcm_afi_log_data.segmentvalue_keyword_mapping ps on l.Segment_Value_1 = ps.Paid_Search_Keyword_ID
)
group by Site_Name_Clean, Channel, Product

-- Join the categorically mapped data by placement to the unioned impression, click and activity table
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_complete_logs AS
(
select l.*, p.Channel, p.Stage_Of_Funnel, p.Site_Name_Clean, ps.Brand_Nonbrand,
case when p.Product = 'Unspecified' and l.Campaign_ID = '26535238' then ps.Product else p.Product end as Product
from americanfamily.dcm_afi_log_data.jan_march_logs l
left join americanfamily.dcm_afi_log_data.placement_categorical_details p on l.Placement_ID = p.Placement_ID
left join americanfamily.dcm_afi_log_data.segmentvalue_keyword_mapping ps on l.Segment_Value_1 = ps.Paid_Search_Keyword_ID
where l.User_ID != '0'
)

CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_master AS
(
	select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
	case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean, concat(Channel, '-', Site_Name_Clean) as Channel_Publisher, Product,
	case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
	case when Event_Type = 'CLICK' then 1 else 0 end as Click,
	case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
	from americanfamily.dcm_afi_log_data.jan_march_complete_logs
)

----------------------------------------------------------------------------------END OF CREATING THE MASTER LOG DATA TABLE-----------------------------------------------------------------------------

----------------------------------------------------------------------------------BEGIN PATH TO CONVERSION ANALYSIS-----------------------------------------------------------------------------

--Quick check to see % of people that converted once and the percentage that converted more than once
select sum(case when Conversion_Count = 1 then 1 else 0 end) / count(Conversion_Count) as One_Time_Converters_Pct, sum(case when Conversion_Count > 1 then 1 else 0 end) / count(Conversion_Count) as Multi_Converters_Pct
from
(
	select User_ID, countif(Event_Type='CONVERSION') as Conversion_Count
	from americanfamily.dcm_afi_log_data.jan_march_complete_logs
	group by User_ID
	having countif(Event_Type='CONVERSION') >= 1
	)
	
--Create a table for the first conversion data across users from January to March - we will use this to join back to the complete logs table later
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_first_conversion_date AS
(
	select User_ID, min(Conversion_Date) as First_Conversion
	from (
		select *
		from (
			select User_ID, case when Event_Type = 'CONVERSION' then Event_Date else null end as Conversion_Date
			from americanfamily.dcm_afi_log_data.jan_march_complete_logs
		)
		where Conversion_Date is not null
	)
	group by User_ID
	)

--Create a table for the last conversion data point across users from January to March - we will use this to join back to the complete logs table later
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_last_conversion_date AS
(
	select User_ID, max(Conversion_Date) as Last_Conversion
	from (
		select *
		from (
			select User_ID, case when Event_Type = 'CONVERSION' then Event_Date else null end as Conversion_Date
			from americanfamily.dcm_afi_log_data.jan_march_complete_logs
		)
		where Conversion_Date is not null
	)
	group by User_ID
	)

--Select all activities from the logs that either came before or is the first conversion event
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion AS
(
	select *
	from (
		select l.*, c.First_Conversion
		from americanfamily.dcm_afi_log_data.jan_march_complete_logs l
		left join americanfamily.dcm_afi_log_data.jan_march_first_conversion_date c on l.User_ID = c.User_ID
		)
	where Event_Date <= First_Conversion
	)

--Select all activities from the logs that occur up to the latest conversion event
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs_last_conversion AS
(
	select *
	from (
		select l.*, c.Last_Conversion
		from americanfamily.dcm_afi_log_data.jan_march_complete_logs l
		left join americanfamily.dcm_afi_log_data.jan_march_last_conversion_date c on l.User_ID = c.User_ID
		)
	where Event_Date <= Last_Conversion
	)

-- Select users, channel, the date of their first touchpoint with the channel, the date of their last touchpoint with the channel and keys to join first touch and last touch
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs_user_first_touch_last_touch AS 
(
	select User_ID, Channel, min(Event_Date) as First_Touch_Date, max(Event_Date) as Last_Touch_Date, concat(User_ID, min(Event_Date)) as First_Touch_Key, concat(User_ID, max(Event_Date)) as Last_Touch_Key
	from americanfamily.dcm_afi_log_data.jan_march_master
	group by User_ID, Channel
	)
	
select User_ID, min(Event_Date) as First_Touch_Date, concat(User_ID, min(Event_Date)) as First_Touch_Key
from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
group by User_ID

select User_ID, max(Event_Date) as Last_Touch_Date, concat(User_ID, min(Event_Date)) as Last_Touch_Key
from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
group by User_ID

select User_ID, Channel, Event_Date, concat(User_ID, Event_Date) as Key
from americanfamily.dcm_afi_log_data.jan_march_master

-- select all users that converted only once, the first touch channel and the channel that they converted on
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs_one_conversion_users_ft_lt AS
(
	select a.User_ID, b.Channel as First_Touch_Channel, c.Channel as Last_Touch_Channel
	from (
		select User_ID, min(Event_Date) as First_Touch_Date, max(Event_Date) as Last_Touch_Date, concat(User_ID, min(Event_Date)) as First_Touch_Key, concat(User_ID, max(Event_Date)) as Last_Touch_Key
		from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
		group by User_ID
		) a
	left join (	
		select User_ID, Channel, Event_Date, concat(User_ID, Event_Date) as Key
		from americanfamily.dcm_afi_log_data.jan_march_master
		) b on a.First_Touch_Key = b.Key
	left join (
		select User_ID, Channel, Event_Date, concat(User_ID, Event_Date) as Key
		from americanfamily.dcm_afi_log_data.jan_march_master
		) c on a.Last_Touch_Key = c.Key
	)

-- select all users that converted multiple times, the first touch channel and the channel that they last converted on
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_logs_multi_conversion_users_ft_lt AS
(
	select a.User_ID, b.Channel as First_Touch_Channel, c.Channel as Last_Touch_Channel
	from (
		select User_ID, min(Event_Date) as First_Touch_Date, max(Event_Date) as Last_Touch_Date, concat(User_ID, min(Event_Date)) as First_Touch_Key, concat(User_ID, max(Event_Date)) as Last_Touch_Key
		from americanfamily.dcm_afi_log_data.jan_march_logs_last_conversion
		group by User_ID
		) a
	left join (	
		select User_ID, Channel, Event_Date, concat(User_ID, Event_Date) as Key
		from americanfamily.dcm_afi_log_data.jan_march_master
		) b on a.First_Touch_Key = b.Key
	left join (
		select User_ID, Channel, Event_Date, concat(User_ID, Event_Date) as Key
		from americanfamily.dcm_afi_log_data.jan_march_master
		) c on a.Last_Touch_Key = c.Key
	)	
	
-- Select the number of touchpoints for each user, leading up to the first conversion, as well as the time it took them to convert in days
select a.User_ID, sum(a.Impression) as Impression, sum(a.Click) as Click, sum(a.Conversion) as Conversion, count(a.Channel) as No_Of_Touchpoints, date_diff(max(a.Event_Date), min(a.Event_Date),day) as Time_To_Convert,
b.First_Touch_Channel, b.Last_Touch_Channel
from (
    select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
    case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
    case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
    case when Event_Type = 'CLICK' then 1 else 0 end as Click,
    case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
    from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
) a
left join americanfamily.dcm_afi_log_data.jan_march_logs_one_conversion_users_ft_lt b on a.User_ID = b.User_ID
group by a.User_ID, b.First_Touch_Channel, b.Last_Touch_Channel

-- Select the number of touchpoints for each user for users that converted more than once, with the last touchpoint being the latest conversion event
select a.User_ID, sum(a.Impression) as Impression, sum(a.Click) as Click, sum(a.Conversion) as Conversion, count(a.Channel) as No_Of_Touchpoints, date_diff(max(a.Event_Date), min(a.Event_Date),day) as Time_To_Convert,
b.First_Touch_Channel, b.Last_Touch_Channel
from (
    select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel, Site_Name_Clean, Impression, Click, Conversion
	from (
		select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
		case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
		case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
		case when Event_Type = 'CLICK' then 1 else 0 end as Click,
		case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
		from americanfamily.dcm_afi_log_data.jan_march_logs_last_conversion
	)
	where User_ID in (
		select User_ID
		from (
			select User_ID, sum(Conversion) as Conversion
			from (
				select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
				case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
				case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
				case when Event_Type = 'CLICK' then 1 else 0 end as Click,
				case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
				from americanfamily.dcm_afi_log_data.jan_march_complete_logs
			)
			group by User_ID
		)
		where Conversion > 1
    )
) a
left join americanfamily.dcm_afi_log_data.jan_march_logs_multi_conversion_users_ft_lt b on a.User_ID = b.User_ID
group by a.User_ID, b.First_Touch_Channel, b.Last_Touch_Channel

-- Select User_ID, Event_Date, Channel and performance metrics from the table with the latetst conversion event as the last touchpoint

--Impression, Click and Conversion data flagged by Channel for all users (change the from table if you want to look at just users that have converted once)
select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
from (
	select case when Native_Display > 0 then 1 else 0 end as Native_Display,
	case when Social > 0 then 1 else 0 end as Social,
	case when Video > 0 then 1 else 0 end as Video,
	case when Search > 0 then 1 else 0 end as Search,
	case when Display > 0 then 1 else 0 end as Display,
	case when CTV > 0 then 1 else 0 end as CTV,
	case when Audio > 0 then 1 else 0 end as Audio,
	case when Audio_Companion_Banner > 0 then 1 else 0 end as Audio_Companion_Banner,
	Unique_Users, Impression, Click, Conversion
	from (
		select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
		from (
			select User_ID, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, countif(Native_Display = 1) as Native_Display, countif(Social = 1) as Social, countif(Video = 1) as Video, countif(Search = 1) as Search, countif(Display = 1) as Display, countif(CTV = 1) as CTV, countif(Audio = 1) as Audio, countif(Audio_Companion_Banner = 1) as Audio_Companion_Banner
			from
				(
				select User_ID, Impression, Click, Conversion,
				case when Channel = 'Native Display' then 1 else 0 end as Native_Display,
				case when Channel = 'Social' then 1 else 0 end as Social,
				case when Channel = 'Video' then 1 else 0 end as Video,
				case when Channel = 'Search' then 1 else 0 end as Search,
				case when Channel = 'Display' then 1 else 0 end as Display,
				case when Channel = 'CTV' then 1 else 0 end as CTV,
				case when Channel = 'Audio' then 1 else 0 end as Audio,
				case when Channel = 'Audio Companion Banner' then 1 else 0 end as Audio_Companion_Banner
				from (
					select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
					case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
					case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
					case when Event_Type = 'CLICK' then 1 else 0 end as Click,
					case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
					from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
				)
			)
			group by User_ID	
		)
		group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner
	)
)
group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner

--Impression, Click and Conversion data flagged by Channel for users that converted more than once
select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
from (
	select case when Native_Display > 0 then 1 else 0 end as Native_Display,
	case when Social > 0 then 1 else 0 end as Social,
	case when Video > 0 then 1 else 0 end as Video,
	case when Search > 0 then 1 else 0 end as Search,
	case when Display > 0 then 1 else 0 end as Display,
	case when CTV > 0 then 1 else 0 end as CTV,
	case when Audio > 0 then 1 else 0 end as Audio,
	case when Audio_Companion_Banner > 0 then 1 else 0 end as Audio_Companion_Banner,
	Unique_Users, Impression, Click, Conversion
	from (
		select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
		from (
			select User_ID, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, countif(Native_Display = 1) as Native_Display, countif(Social = 1) as Social, countif(Video = 1) as Video, countif(Search = 1) as Search, countif(Display = 1) as Display, countif(CTV = 1) as CTV, countif(Audio = 1) as Audio, countif(Audio_Companion_Banner = 1) as Audio_Companion_Banner
			from
				(
				select User_ID, Impression, Click, Conversion,
				case when Channel = 'Native Display' then 1 else 0 end as Native_Display,
				case when Channel = 'Social' then 1 else 0 end as Social,
				case when Channel = 'Video' then 1 else 0 end as Video,
				case when Channel = 'Search' then 1 else 0 end as Search,
				case when Channel = 'Display' then 1 else 0 end as Display,
				case when Channel = 'CTV' then 1 else 0 end as CTV,
				case when Channel = 'Audio' then 1 else 0 end as Audio,
				case when Channel = 'Audio Companion Banner' then 1 else 0 end as Audio_Companion_Banner
				from (
					select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel, Site_Name_Clean, Impression, Click, Conversion
					from (
						select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
						case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
						case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
						case when Event_Type = 'CLICK' then 1 else 0 end as Click,
						case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
						from americanfamily.dcm_afi_log_data.jan_march_complete_logs
					)
					where User_ID in (
						select User_ID
						from (
							select User_ID, sum(Conversion) as Conversion
							from (
								select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
								case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
								case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
								case when Event_Type = 'CLICK' then 1 else 0 end as Click,
								case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
								from americanfamily.dcm_afi_log_data.jan_march_complete_logs
							)
							group by User_ID
						)
						where Conversion > 1
					)
				)
			)
			group by User_ID	
		)
		group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner
	)
)
group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner

-- select channel paths and the number of touchpoints for each channel path for both converting and non converting paths for all users
CREATE TABLE americanfamily.dcm_afi_log_data.jan_march_channel_pathes AS (
	select Channel_Path, No_Of_Touchpoints, sum(Conversion) as Conversion, sum(Null_Conversion) as Null_Conversion
	from (
		select User_ID, array_to_string(array_agg(Channel order by Event_Date asc), ' > ') as Channel_Path, array_length(array_agg(Channel order by Event_Date asc)) as No_Of_Touchpoints, sum(Conversion) as Conversion, sum(Null_Conversion) as Null_Conversion
		from (
			select User_ID, Event_Date, Channel, Conversion, case when Conversion > 0 then 0 else 1 end as Null_Conversion
			from (
				select User_ID, Event_Date, Channel, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
				from americanfamily.dcm_afi_log_data.jan_march_master
				group by User_ID, Event_Date, Channel
			)
		)
		group by User_ID
	)
	
	group by Channel_Path, No_Of_Touchpoints
)

----------------------------------------- END OF PATH TO CONVERSION ANALYSIS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------- BEGIN CROSS CHANNEL OVERLAP ANALYSIS -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Select all impression combinations by groups of users for all users that only converted once on any channel
select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, sum(Native_Display_Impression) as Native_Display_Impression, sum(Social_Impression) as Social_Impression, sum(Video_Impression) as Video_Impression,
sum(Search_Impression) as Search_Impression, sum(Display_Impression) as Display_Impression, sum(CTV_Impression) as CTV_Impression, sum(Audio_Impression) as Audio_Impression, sum(Audio_Companion_Banner_Impression) as Audio_Companion_Banner_Impression
from (
	select case when Native_Display > 0 then 1 else 0 end as Native_Display,
	case when Social > 0 then 1 else 0 end as Social,
	case when Video > 0 then 1 else 0 end as Video,
	case when Search > 0 then 1 else 0 end as Search,
	case when Display > 0 then 1 else 0 end as Display,
	case when CTV > 0 then 1 else 0 end as CTV,
	case when Audio > 0 then 1 else 0 end as Audio,
	case when Audio_Companion_Banner > 0 then 1 else 0 end as Audio_Companion_Banner,
	Unique_Users, Impression, Native_Display_Impression, Social_Impression, Video_Impression, Search_Impression, Display_Impression, CTV_Impression, Audio_Impression, Audio_Companion_Banner_Impression
	from (
		select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, count(User_ID) as Unique_Users, sum(Impression) as Impression,
		sum(Native_Display) as Native_Display_Impression, sum(Social) as Social_Impression, sum(Video) as Video_Impression, sum(Search) as Search_Impression, sum(Display) as Display_Impression, sum(CTV) as CTV_Impression, sum(Audio) as Audio_Impression, sum(Audio_Companion_Banner) as Audio_Companion_Banner_Impression
		from (
			select User_ID, sum(Impression) as Impression, countif(Native_Display = 1) as Native_Display, countif(Social = 1) as Social, countif(Video = 1) as Video, countif(Search = 1) as Search, countif(Display = 1) as Display, countif(CTV = 1) as CTV, countif(Audio = 1) as Audio, countif(Audio_Companion_Banner = 1) as Audio_Companion_Banner
			from
				(
				select User_ID, Impression,
				case when Channel = 'Native Display' and Impression = 1 then 1 else 0 end as Native_Display,
				case when Channel = 'Social' and Impression = 1 then 1 else 0 end as Social,
				case when Channel = 'Video' and Impression = 1 then 1 else 0 end as Video,
				case when Channel = 'Search' and Impression = 1 then 1 else 0 end as Search,
				case when Channel = 'Display' and Impression = 1 then 1 else 0 end as Display,
				case when Channel = 'CTV' and Impression = 1 then 1 else 0 end as CTV,
				case when Channel = 'Audio' and Impression = 1 then 1 else 0 end as Audio,
				case when Channel = 'Audio Companion Banner' and Impression = 1 then 1 else 0 end as Audio_Companion_Banner
				from (
					select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
					case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
					case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
					case when Event_Type = 'CLICK' then 1 else 0 end as Click,
					case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
					from americanfamily.dcm_afi_log_data.jan_march_logs_first_conversion
				)
			)
			group by User_ID	
		)
		group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner
	)
)
group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner

-- Select all impression combinations by groups of users for all users
select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, sum(Native_Display_Impression) as Native_Display_Impression, sum(Social_Impression) as Social_Impression, sum(Video_Impression) as Video_Impression,
sum(Search_Impression) as Search_Impression, sum(Display_Impression) as Display_Impression, sum(CTV_Impression) as CTV_Impression, sum(Audio_Impression) as Audio_Impression, sum(Audio_Companion_Banner_Impression) as Audio_Companion_Banner_Impression
from (
	select case when Native_Display > 0 then 1 else 0 end as Native_Display,
	case when Social > 0 then 1 else 0 end as Social,
	case when Video > 0 then 1 else 0 end as Video,
	case when Search > 0 then 1 else 0 end as Search,
	case when Display > 0 then 1 else 0 end as Display,
	case when CTV > 0 then 1 else 0 end as CTV,
	case when Audio > 0 then 1 else 0 end as Audio,
	case when Audio_Companion_Banner > 0 then 1 else 0 end as Audio_Companion_Banner,
	Unique_Users, Impression, Click, Conversion, Native_Display_Impression, Social_Impression, Video_Impression, Search_Impression, Display_Impression, CTV_Impression, Audio_Impression, Audio_Companion_Banner_Impression
	from (
		select Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner, count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion,
		sum(Native_Display) as Native_Display_Impression, sum(Social) as Social_Impression, sum(Video) as Video_Impression, sum(Search) as Search_Impression, sum(Display) as Display_Impression, sum(CTV) as CTV_Impression, sum(Audio) as Audio_Impression, sum(Audio_Companion_Banner) as Audio_Companion_Banner_Impression
		from (
			select User_ID, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, countif(Native_Display = 1) as Native_Display, countif(Social = 1) as Social, countif(Video = 1) as Video, countif(Search = 1) as Search, countif(Display = 1) as Display, countif(CTV = 1) as CTV, countif(Audio = 1) as Audio, countif(Audio_Companion_Banner = 1) as Audio_Companion_Banner
			from
				(
				select User_ID, Impression, Click, Conversion,
				case when Channel = 'Native Display' and Impression = 1 then 1 else 0 end as Native_Display,
				case when Channel = 'Social' and Impression = 1 then 1 else 0 end as Social,
				case when Channel = 'Video' and Impression = 1 then 1 else 0 end as Video,
				case when Channel = 'Search' and Impression = 1 then 1 else 0 end as Search,
				case when Channel = 'Display' and Impression = 1 then 1 else 0 end as Display,
				case when Channel = 'CTV' and Impression = 1 then 1 else 0 end as CTV,
				case when Channel = 'Audio' and Impression = 1 then 1 else 0 end as Audio,
				case when Channel = 'Audio Companion Banner' and Impression = 1 then 1 else 0 end as Audio_Companion_Banner
				from (
					select User_ID, Event_Date, Active_View_Measurable_Impressions, Active_View_Eligible_Impressions, Active_View_Viewable_Impressions, Channel, Stage_Of_Funnel,
					case when Brand_Nonbrand in ('Brand', 'Nonbrand') then concat(Site_Name_Clean, '-', Brand_Nonbrand) else Site_Name_Clean end as Site_Name_Clean,
					case when Event_Type = 'VIEW' then 1 else 0 end as Impression,
					case when Event_Type = 'CLICK' then 1 else 0 end as Click,
					case when Event_Type = 'CONVERSION' then 1 else 0 end as Conversion
					from americanfamily.dcm_afi_log_data.jan_march_complete_logs
				)
			)
			group by User_ID	
		)
		group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner
	)
)
group by Native_Display, Social, Video, Search, Display, CTV, Audio, Audio_Companion_Banner

--Select impression and user total for channel and publisher combinations for all users
select Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, 
sum(Display_Media_IQ_Impression) as Display_Media_IQ_Impression, sum(Video_HTS_Impression) as Video_HTS_Impression, sum(Display_Waze_Impression) as Display_Waze_Impression, sum(Display_ESPN_Impression) as Display_ESPN_Impression, sum(Video_AdTheorent_Impression) as Video_AdTheorent_Impression,
sum(Display_Verizon_Impression) as Display_Verizon_Impression, sum(Video_Youtube_Impression) as Video_Youtube_Impression, sum(Video_Vevo_Impression) as Video_Vevo_Impression, sum(Display_TedX_Impression) as Display_TedX_Impression, sum(Display_Zillow_Impression) as Display_Zillow_Impression, 
sum(Display_Quantcast_Impression) as Display_Quantcast_Impression, sum(Audio_Pandora_Impression) as Audio_Pandora_Impression, sum(Video_Hulu_Impression) as Video_Hulu_Impression, sum(Display_AdTheorent_Impression) as Display_AdTheorent_Impression
from (
	select case when Display_Media_IQ > 0 then 1 else 0 end as Display_Media_IQ,
	case when Video_HTS > 0 then 1 else 0 end as Video_HTS,
	case when Display_Waze > 0 then 1 else 0 end as Display_Waze,
	case when Display_ESPN > 0 then 1 else 0 end as Display_ESPN,
	case when Video_AdTheorent > 0 then 1 else 0 end as Video_AdTheorent,
	case when Display_Verizon > 0 then 1 else 0 end as Display_Verizon,
	case when Video_Youtube > 0 then 1 else 0 end as Video_Youtube,
	case when Video_Vevo > 0 then 1 else 0 end as Video_Vevo,
	case when Display_TedX > 0 then 1 else 0 end as Display_TedX,
	case when Display_Zillow > 0 then 1 else 0 end as Display_Zillow,
	case when Display_Quantcast > 0 then 1 else 0 end as Display_Quantcast,
	case when Audio_Pandora > 0 then 1 else 0 end as Audio_Pandora,
	case when Video_Hulu > 0 then 1 else 0 end as Video_Hulu,
	case when Display_AdTheorent > 0 then 1 else 0 end as Display_AdTheorent,
	Unique_Users, Impression, Display_Media_IQ_Impression, Video_HTS_Impression, Display_Waze_Impression, Display_ESPN_Impression, Video_AdTheorent_Impression, Display_Verizon_Impression, Video_Youtube_Impression, Video_Vevo_Impression, Display_TedX_Impression, 
	Display_Zillow_Impression, Display_Quantcast_Impression, Audio_Pandora_Impression, Video_Hulu_Impression, Display_AdTheorent_Impression
	from (
		select Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent,
		count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Display_Media_IQ) as Display_Media_IQ_Impression, sum(Video_HTS) as Video_HTS_Impression, sum(Display_Waze) as Display_Waze_Impression, sum(Display_ESPN) as Display_ESPN_Impression,
		sum(Video_AdTheorent) as Video_AdTheorent_Impression, sum(Display_Verizon) as Display_Verizon_Impression, sum(Video_Youtube) as Video_Youtube_Impression, sum(Video_Vevo) as Video_Vevo_Impression, sum(Display_TedX) as Display_TedX_Impression,
		sum(Display_Zillow) as Display_Zillow_Impression, sum(Display_Quantcast) as Display_Quantcast_Impression, sum(Audio_Pandora) as Audio_Pandora_Impression, sum(Video_Hulu) as Video_Hulu_Impression, sum(Display_AdTheorent) as Display_AdTheorent_Impression
		from (
			select User_ID, sum(Impression) as Impression, countif(Display_Media_IQ = 1) as Display_Media_IQ, countif(Video_HTS = 1) as Video_HTS, countif(Display_Waze = 1) as Display_Waze, countif(Display_ESPN = 1) as Display_ESPN, 
			countif(Video_AdTheorent = 1) as Video_AdTheorent, countif(Display_Verizon = 1) as Display_Verizon, countif(Video_Youtube = 1) as Video_Youtube, countif(Video_Vevo = 1) as Video_Vevo, countif(Display_TedX = 1) as Display_TedX,
			countif(Display_Zillow = 1) as Display_Zillow, countif(Display_Quantcast = 1) as Display_Quantcast, countif(Audio_Pandora = 1) as Audio_Pandora, countif(Video_Hulu = 1) as Video_Hulu, countif(Display_AdTheorent = 1) as Display_AdTheorent
			from (
				select User_ID, Impression
				case when Channel_Publisher = 'Display-Media IQ' and Impression = 1 then 1 else 0 end as Display_Media_IQ,
				case when Channel_Publisher = 'Video-Home Team Sport' and Impression = 1 then 1 else 0 end as Video_HTS,
				case when Channel_Publisher = 'Display-Waze' and Impression = 1 then 1 else 0 end as Display_Waze,
				case when Channel_Publisher = 'Display-ESPN' and Impression = 1 then 1 else 0 end as Display_ESPN,
				case when Channel_Publisher = 'Video-AdTheorent' and Impression = 1 then 1 else 0 end as Video_AdTheorent,
				case when Channel_Publisher = 'Display-Verizon' and Impression = 1 then 1 else 0 end as Display_Verizon,
				case when Channel_Publisher = 'Video-Youtube' and Impression = 1 then 1 else 0 end as Video_Youtube,
				case when Channel_Publisher = 'Video-Vevo' and Impression = 1 then 1 else 0 end as Video_Vevo,
				case when Channel_Publisher = 'Display-TedX' and Impression = 1 then 1 else 0 end as Display_TedX,
				case when Channel_Publisher = 'Display-Zillow' and Impression = 1 then 1 else 0 end as Display_Zillow,
				case when Channel_Publisher = 'Display-Quantcast' and Impression = 1 then 1 else 0 end as Display_Quantcast,
				case when Channel_Publisher = 'Audio-Pandora' and Impression = 1 then 1 else 0 end as Audio_Pandora,
				case when Channel_Publisher = 'Video-Hulu' and Impression = 1 then 1 else 0 end as Video_Hulu,
				case when Channel_Publisher = 'Display-AdTheorent' and Impression = 1 then 1 else 0 end as Display_AdTheorent
				from (
					select *
					from americanfamily.dcm_afi_log_data.jan_march_master
					where Channel_Publisher in ('Display-Media IQ', 'Video-Home Team Sport', 'Display-Waze', 'Display-ESPN', 'Video-AdTheorent',
					'Display-Verizon', 'Video-Youtube', 'Video-Vevo', 'Display-TedX', 'Display-Zillow', 'Display-Quantcast', 'Audio-Pandora', 'Video-Hulu', 'Display-AdTheorent')
				)
			)
			group by User_ID
		)
		group by Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent
	)	
)
group by Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent


select Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent, sum(Unique_Users) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, 
sum(Display_Media_IQ_Impression) as Display_Media_IQ_Impression, sum(Video_HTS_Impression) as Video_HTS_Impression, sum(Display_Waze_Impression) as Display_Waze_Impression, sum(Display_ESPN_Impression) as Display_ESPN_Impression, sum(Video_AdTheorent_Impression) as Video_AdTheorent_Impression,
sum(Display_Verizon_Impression) as Display_Verizon_Impression, sum(Video_Youtube_Impression) as Video_Youtube_Impression, sum(Video_Vevo_Impression) as Video_Vevo_Impression, sum(Display_TedX_Impression) as Display_TedX_Impression, sum(Display_Zillow_Impression) as Display_Zillow_Impression, 
sum(Display_Quantcast_Impression) as Display_Quantcast_Impression, sum(Audio_Pandora_Impression) as Audio_Pandora_Impression, sum(Video_Hulu_Impression) as Video_Hulu_Impression, sum(Display_AdTheorent_Impression) as Display_AdTheorent_Impression
from (
	select case when Display_Media_IQ > 0 then 1 else 0 end as Display_Media_IQ,
	case when Video_HTS > 0 then 1 else 0 end as Video_HTS,
	case when Display_Waze > 0 then 1 else 0 end as Display_Waze,
	case when Display_ESPN > 0 then 1 else 0 end as Display_ESPN,
	case when Video_AdTheorent > 0 then 1 else 0 end as Video_AdTheorent,
	case when Display_Verizon > 0 then 1 else 0 end as Display_Verizon,
	case when Video_Youtube > 0 then 1 else 0 end as Video_Youtube,
	case when Video_Vevo > 0 then 1 else 0 end as Video_Vevo,
	case when Display_TedX > 0 then 1 else 0 end as Display_TedX,
	case when Display_Zillow > 0 then 1 else 0 end as Display_Zillow,
	case when Display_Quantcast > 0 then 1 else 0 end as Display_Quantcast,
	case when Audio_Pandora > 0 then 1 else 0 end as Audio_Pandora,
	case when Video_Hulu > 0 then 1 else 0 end as Video_Hulu,
	case when Display_AdTheorent > 0 then 1 else 0 end as Display_AdTheorent,
	Unique_Users, Impression, Click, Conversion, Display_Media_IQ_Impression, Video_HTS_Impression, Display_Waze_Impression, Display_ESPN_Impression, Video_AdTheorent_Impression, Display_Verizon_Impression, Video_Youtube_Impression, Video_Vevo_Impression, Display_TedX_Impression, 
	Display_Zillow_Impression, Display_Quantcast_Impression, Audio_Pandora_Impression, Video_Hulu_Impression, Display_AdTheorent_Impression
	from (
		select Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent,
		count(User_ID) as Unique_Users, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, sum(Display_Media_IQ) as Display_Media_IQ_Impression, sum(Video_HTS) as Video_HTS_Impression, sum(Display_Waze) as Display_Waze_Impression, sum(Display_ESPN) as Display_ESPN_Impression,
		sum(Video_AdTheorent) as Video_AdTheorent_Impression, sum(Display_Verizon) as Display_Verizon_Impression, sum(Video_Youtube) as Video_Youtube_Impression, sum(Video_Vevo) as Video_Vevo_Impression, sum(Display_TedX) as Display_TedX_Impression,
		sum(Display_Zillow) as Display_Zillow_Impression, sum(Display_Quantcast) as Display_Quantcast_Impression, sum(Audio_Pandora) as Audio_Pandora_Impression, sum(Video_Hulu) as Video_Hulu_Impression, sum(Display_AdTheorent) as Display_AdTheorent_Impression
		from (
			select User_ID, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion, countif(Display_Media_IQ = 1) as Display_Media_IQ, countif(Video_HTS = 1) as Video_HTS, countif(Display_Waze = 1) as Display_Waze, countif(Display_ESPN = 1) as Display_ESPN, 
			countif(Video_AdTheorent = 1) as Video_AdTheorent, countif(Display_Verizon = 1) as Display_Verizon, countif(Video_Youtube = 1) as Video_Youtube, countif(Video_Vevo = 1) as Video_Vevo, countif(Display_TedX = 1) as Display_TedX,
			countif(Display_Zillow = 1) as Display_Zillow, countif(Display_Quantcast = 1) as Display_Quantcast, countif(Audio_Pandora = 1) as Audio_Pandora, countif(Video_Hulu = 1) as Video_Hulu, countif(Display_AdTheorent = 1) as Display_AdTheorent
			from (
				select User_ID, Impression, Click, Conversion,
				case when Channel_Publisher = 'Display-Media IQ' and Impression = 1 then 1 else 0 end as Display_Media_IQ,
				case when Channel_Publisher = 'Video-Home Team Sport' and Impression = 1 then 1 else 0 end as Video_HTS,
				case when Channel_Publisher = 'Display-Waze' and Impression = 1 then 1 else 0 end as Display_Waze,
				case when Channel_Publisher = 'Display-ESPN' and Impression = 1 then 1 else 0 end as Display_ESPN,
				case when Channel_Publisher = 'Video-AdTheorent' and Impression = 1 then 1 else 0 end as Video_AdTheorent,
				case when Channel_Publisher = 'Display-Verizon' and Impression = 1 then 1 else 0 end as Display_Verizon,
				case when Channel_Publisher = 'Video-Youtube' and Impression = 1 then 1 else 0 end as Video_Youtube,
				case when Channel_Publisher = 'Video-Vevo' and Impression = 1 then 1 else 0 end as Video_Vevo,
				case when Channel_Publisher = 'Display-TedX' and Impression = 1 then 1 else 0 end as Display_TedX,
				case when Channel_Publisher = 'Display-Zillow' and Impression = 1 then 1 else 0 end as Display_Zillow,
				case when Channel_Publisher = 'Display-Quantcast' and Impression = 1 then 1 else 0 end as Display_Quantcast,
				case when Channel_Publisher = 'Audio-Pandora' and Impression = 1 then 1 else 0 end as Audio_Pandora,
				case when Channel_Publisher = 'Video-Hulu' and Impression = 1 then 1 else 0 end as Video_Hulu,
				case when Channel_Publisher = 'Display-AdTheorent' and Impression = 1 then 1 else 0 end as Display_AdTheorent
				from (
					select *
					from americanfamily.dcm_afi_log_data.jan_march_master
					where Channel_Publisher in ('Display-Media IQ', 'Video-Home Team Sport', 'Display-Waze', 'Display-ESPN', 'Video-AdTheorent',
					'Display-Verizon', 'Video-Youtube', 'Video-Vevo', 'Display-TedX', 'Display-Zillow', 'Display-Quantcast', 'Audio-Pandora', 'Video-Hulu', 'Display-AdTheorent')
				)
			)
			group by User_ID
		)
		group by Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent
	)	
)
group by Display_Media_IQ, Video_HTS, Display_Waze, Display_ESPN, Video_AdTheorent, Display_Verizon, Video_Youtube, Video_Vevo, Display_TedX, Display_Zillow, Display_Quantcast, Audio_Pandora, Video_Hulu, Display_AdTheorent

-------------------------------------------------------------------- END OF CROSS CHANNEL OVERLAP ANALYSIS ------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------- BEGIN FREQUENCY CAP DEEP DIVE ------------------------------------------------------------------------------------------------------------------------

-- See what the average impression frequency for each publisher at the conversion stage for Display
select Site_Name_Clean, Product, sum(Impression) as Impression, count(distinct User_ID) as Total_Unique_Reach, sum(Impression) / count(distinct User_ID) as Avg_Impression_Frequency
from americanfamily.dcm_afi_log_data.jan_march_master
where Channel = 'Display' and Stage_Of_Funnel = 'Conversion'
group by Site_Name_Clean, Product

-- Impression frequency by publisher and product for display at the conversion stage of funnel
select Impression, count(distinct User_ID) as Total_Unique_Users, sum(Click) as Click, sum(Conversion) as Conversion, sum(Conversion)/count(distinct User_ID) as Conversion_Rate
from (
	select User_ID, Site_Name_Clean, Product, sum(Impression) as Impression, sum(Click) as Click, sum(Conversion) as Conversion
	from americanfamily.dcm_afi_log_data.jan_march_master
	where Channel = 'Display' and Stage_Of_Funnel = 'Conversion'
	group by User_ID, Site_Name_Clean, Product
)
where Site_Name_Clean = 'Quantcast' and Product = 'Auto'
group by Impression
order by 1