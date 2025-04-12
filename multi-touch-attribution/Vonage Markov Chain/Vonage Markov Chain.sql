--JOIN IMPRESSION, CLICK AND ACTIVITY TABLE FOR LEAD SUBMISSION FLOODLIGHTS--
CREATE TABLE AprilLogsLeadSubmissions AS
(
select *
from(
select eventdatetime, userid, advertiserid, campaignid, siteid, adid, placementid, null as activityid, stateregion, cityid, uvalue, null as segmentvalue1, activevieweligibleimpressions, activeviewmeasurableimpressions, activeviewviewableimpressions, eventtype, eventsubtype
from dcm.impression
where placementid in (270548757, 270216872, 270217637, 271077772, 270572520, 270217613, 270170330, 256146151, 256146094, 256147252, 258555317, 256147276, 256528060, 258555290, 256146085,
261825245, 270456634, 270200985, 270359025, 270359031, 270200988, 256147162, 268999905, 256146124, 256146046, 256670468, 268998786, 257176446, 268648443, 258555296, 270115324, 256731116,
262603175, 270216398, 270733173, 268444473, 256146127, 259943568, 256147171, 256146088, 262145593, 261832400, 270169538, 258669735, 270214196, 270214205, 270170984, 270171197, 258555281,
256146061, 270548745, 270573045, 262598399, 270214208, 270269005, 270455992, 256147189, 270726867, 256284429, 256147168, 270193508, 270193535, 270216650, 269857487, 256146163, 257319514,
258252515, 262590143, 256146190, 270358830, 270359889, 270216635, 270358842, 258555299, 259853479, 256147183, 256147279, 256284468, 270456622, 256146160, 268352075, 270216848, 256146166,
256146049, 256528081, 256147204, 256284450, 258555293, 270193520, 270358833, 270000698, 270732867, 268134428, 268631368, 270214193, 268134416, 270640270, 268948840, 256146145, 256316423,
258555287, 261825230, 256145131, 256528051, 270456628, 270216677, 262351787, 270116449, 270456640, 270572982, 270214259, 270733407, 270216410, 256146055, 256147180, 270456019, 270216830,
270524262, 270524268, 270217388, 256146208, 256147195, 256147177, 256146196, 269857469, 256147216, 270217403, 269857502, 270216845, 270169541, 270473851, 256146142, 255833171, 256146091,
268449735, 270572997, 270216827, 270457129, 270572526, 256147198, 256284477, 256146199, 256284459, 256146037, 256284462, 256284438, 268352108, 270456664, 270217382, 270216647, 269857460, 
256147201, 261825233, 262238967, 262144207, 256316417, 256284486, 256147207, 270522498, 270573003, 268633057, 268435602, 256146121, 268682762, 256146058, 262144216, 256528069, 256147219,
256146187, 268632562, 270170327, 270572532, 256146181, 256146130, 256147258, 256146136, 256528084, 259538996, 258555272, 257165745, 256146103, 270524865, 270640786, 256147264, 256146172,
256316411, 256528054, 258555269, 256146106, 268998078, 256146154, 256146133, 256147273, 256147186, 256528063, 256729799, 270456649, 256146205, 258555278, 256146139, 256284420, 256528072,
270217634, 270116146, 270216632, 256146220, 258555311, 256146157, 256146100, 262143616, 270572505, 256146178, 270000677, 270115279, 270217361, 268145429, 270216653, 258555308, 256528078,
256147270, 256146169, 256707722, 270216638, 270456370, 270171200, 270732549, 256146052, 256146148, 256145308, 256147210, 256725095, 270548754, 270170978, 268444467, 256146184, 270640783,
270457135, 256146175, 259852936, 259853293, 256147261, 256528057, 257111178, 256691561, 270358854, 270193529, 270733167, 269858102, 256147267, 258555314, 262144219, 256145137, 270214256,
270359019, 256147192, 256146202, 270359028, 268940053, 270733176, 270217391, 256146067, 258555284, 256147213, 257135278, 270217616, 256147282, 270573006, 256147165, 270214202, 270573015,
256146214, 256284447, 256284423, 259538180, 268649139, 270524265, 270216833, 270733707, 256146193, 261825236, 256146043, 262238961, 256528066, 262598396, 270522501, 270359898, 270358836,
270473860, 256146064, 256284471, 255830963, 256147174, 256146097, 256146040, 256145140)

UNION ALL

select eventdatetime, userid, advertiserid, campaignid, siteid, adid, placementid, null as activityid, stateregion, cityid, uvalue, segmentvalue1, null as activevieweligibleimpressions, null as activeviewmeasurableimpressions, null as activeviewviewableimpressions, eventtype, eventsubtype
from dcm.click
where placementid in (270548757, 270216872, 270217637, 271077772, 270572520, 270217613, 270170330, 256146151, 256146094, 256147252, 258555317, 256147276, 256528060, 258555290, 256146085,
261825245, 270456634, 270200985, 270359025, 270359031, 270200988, 256147162, 268999905, 256146124, 256146046, 256670468, 268998786, 257176446, 268648443, 258555296, 270115324, 256731116,
262603175, 270216398, 270733173, 268444473, 256146127, 259943568, 256147171, 256146088, 262145593, 261832400, 270169538, 258669735, 270214196, 270214205, 270170984, 270171197, 258555281,
256146061, 270548745, 270573045, 262598399, 270214208, 270269005, 270455992, 256147189, 270726867, 256284429, 256147168, 270193508, 270193535, 270216650, 269857487, 256146163, 257319514,
258252515, 262590143, 256146190, 270358830, 270359889, 270216635, 270358842, 258555299, 259853479, 256147183, 256147279, 256284468, 270456622, 256146160, 268352075, 270216848, 256146166,
256146049, 256528081, 256147204, 256284450, 258555293, 270193520, 270358833, 270000698, 270732867, 268134428, 268631368, 270214193, 268134416, 270640270, 268948840, 256146145, 256316423,
258555287, 261825230, 256145131, 256528051, 270456628, 270216677, 262351787, 270116449, 270456640, 270572982, 270214259, 270733407, 270216410, 256146055, 256147180, 270456019, 270216830,
270524262, 270524268, 270217388, 256146208, 256147195, 256147177, 256146196, 269857469, 256147216, 270217403, 269857502, 270216845, 270169541, 270473851, 256146142, 255833171, 256146091,
268449735, 270572997, 270216827, 270457129, 270572526, 256147198, 256284477, 256146199, 256284459, 256146037, 256284462, 256284438, 268352108, 270456664, 270217382, 270216647, 269857460, 
256147201, 261825233, 262238967, 262144207, 256316417, 256284486, 256147207, 270522498, 270573003, 268633057, 268435602, 256146121, 268682762, 256146058, 262144216, 256528069, 256147219,
256146187, 268632562, 270170327, 270572532, 256146181, 256146130, 256147258, 256146136, 256528084, 259538996, 258555272, 257165745, 256146103, 270524865, 270640786, 256147264, 256146172,
256316411, 256528054, 258555269, 256146106, 268998078, 256146154, 256146133, 256147273, 256147186, 256528063, 256729799, 270456649, 256146205, 258555278, 256146139, 256284420, 256528072,
270217634, 270116146, 270216632, 256146220, 258555311, 256146157, 256146100, 262143616, 270572505, 256146178, 270000677, 270115279, 270217361, 268145429, 270216653, 258555308, 256528078,
256147270, 256146169, 256707722, 270216638, 270456370, 270171200, 270732549, 256146052, 256146148, 256145308, 256147210, 256725095, 270548754, 270170978, 268444467, 256146184, 270640783,
270457135, 256146175, 259852936, 259853293, 256147261, 256528057, 257111178, 256691561, 270358854, 270193529, 270733167, 269858102, 256147267, 258555314, 262144219, 256145137, 270214256,
270359019, 256147192, 256146202, 270359028, 268940053, 270733176, 270217391, 256146067, 258555284, 256147213, 257135278, 270217616, 256147282, 270573006, 256147165, 270214202, 270573015,
256146214, 256284447, 256284423, 259538180, 268649139, 270524265, 270216833, 270733707, 256146193, 261825236, 256146043, 262238961, 256528066, 262598396, 270522501, 270359898, 270358836,
270473860, 256146064, 256284471, 255830963, 256147174, 256146097, 256146040, 256145140)

UNION ALL

select eventdatetime, userid, advertiserid, campaignid, siteid, adid, placementid, activityid, stateregion, null as cityid, uvalue, segmentvalue1, null as activevieweligibleimpressions, null as activeviewmeasureableimpressions, null as activeviewviewableimpressions, eventtype, eventsubtype
from dcm.activity
where placementid in (270548757, 270216872, 270217637, 271077772, 270572520, 270217613, 270170330, 256146151, 256146094, 256147252, 258555317, 256147276, 256528060, 258555290, 256146085,
261825245, 270456634, 270200985, 270359025, 270359031, 270200988, 256147162, 268999905, 256146124, 256146046, 256670468, 268998786, 257176446, 268648443, 258555296, 270115324, 256731116,
262603175, 270216398, 270733173, 268444473, 256146127, 259943568, 256147171, 256146088, 262145593, 261832400, 270169538, 258669735, 270214196, 270214205, 270170984, 270171197, 258555281,
256146061, 270548745, 270573045, 262598399, 270214208, 270269005, 270455992, 256147189, 270726867, 256284429, 256147168, 270193508, 270193535, 270216650, 269857487, 256146163, 257319514,
258252515, 262590143, 256146190, 270358830, 270359889, 270216635, 270358842, 258555299, 259853479, 256147183, 256147279, 256284468, 270456622, 256146160, 268352075, 270216848, 256146166,
256146049, 256528081, 256147204, 256284450, 258555293, 270193520, 270358833, 270000698, 270732867, 268134428, 268631368, 270214193, 268134416, 270640270, 268948840, 256146145, 256316423,
258555287, 261825230, 256145131, 256528051, 270456628, 270216677, 262351787, 270116449, 270456640, 270572982, 270214259, 270733407, 270216410, 256146055, 256147180, 270456019, 270216830,
270524262, 270524268, 270217388, 256146208, 256147195, 256147177, 256146196, 269857469, 256147216, 270217403, 269857502, 270216845, 270169541, 270473851, 256146142, 255833171, 256146091,
268449735, 270572997, 270216827, 270457129, 270572526, 256147198, 256284477, 256146199, 256284459, 256146037, 256284462, 256284438, 268352108, 270456664, 270217382, 270216647, 269857460, 
256147201, 261825233, 262238967, 262144207, 256316417, 256284486, 256147207, 270522498, 270573003, 268633057, 268435602, 256146121, 268682762, 256146058, 262144216, 256528069, 256147219,
256146187, 268632562, 270170327, 270572532, 256146181, 256146130, 256147258, 256146136, 256528084, 259538996, 258555272, 257165745, 256146103, 270524865, 270640786, 256147264, 256146172,
256316411, 256528054, 258555269, 256146106, 268998078, 256146154, 256146133, 256147273, 256147186, 256528063, 256729799, 270456649, 256146205, 258555278, 256146139, 256284420, 256528072,
270217634, 270116146, 270216632, 256146220, 258555311, 256146157, 256146100, 262143616, 270572505, 256146178, 270000677, 270115279, 270217361, 268145429, 270216653, 258555308, 256528078,
256147270, 256146169, 256707722, 270216638, 270456370, 270171200, 270732549, 256146052, 256146148, 256145308, 256147210, 256725095, 270548754, 270170978, 268444467, 256146184, 270640783,
270457135, 256146175, 259852936, 259853293, 256147261, 256528057, 257111178, 256691561, 270358854, 270193529, 270733167, 269858102, 256147267, 258555314, 262144219, 256145137, 270214256,
270359019, 256147192, 256146202, 270359028, 268940053, 270733176, 270217391, 256146067, 258555284, 256147213, 257135278, 270217616, 256147282, 270573006, 256147165, 270214202, 270573015,
256146214, 256284447, 256284423, 259538180, 268649139, 270524265, 270216833, 270733707, 256146193, 261825236, 256146043, 262238961, 256528066, 262598396, 270522501, 270359898, 270358836,
270473860, 256146064, 256284471, 255830963, 256147174, 256146097, 256146040, 256145140) and activityid in (9425280, 8907393, 9401552, 9334158)
)
where eventdatetime >= date '2020-04-07' and eventdatetime <= date '2020-05-12'
);

--MAP OUT ALL OF THE PAID SEARCH STUFF BY KEYWORDS
CREATE TABLE AprilSearchKeywordMap AS (

select distinct a.segmentvalue1, ps.paidsearchlegacykeywordid, ps.paidsearchkeyword,
case when ps.paidsearchkeyword like '%vonage%' 
or ps.paidsearchkeyword like '%nexmo%' 
or ps.paidsearchkeyword like '%tokbox%' 
or ps.paidsearchkeyword like '%opentok%' 
or ps.paidsearchkeyword like '%open%' 
or ps.paidsearchkeyword like '%tok%' 
or ps.paidsearchkeyword like '%box%' 
or ps.paidsearchkeyword like '%open%' 
or ps.paidsearchkeyword like '%von%' 
or ps.paidsearchkeyword like '%vocal%'
or ps.paidsearchkeyword like '%voc%'
or ps.paidsearchkeyword like '%vo1%'
or ps.paidsearchkeyword like '%ve1%'
or ps.paidsearchkeyword like '%voy%'
or ps.paidsearchkeyword like '%newvoicemedia%'
or ps.paidsearchkeyword like '%nvm'
or ps.paidsearchkeyword like '%contactworld%'
or ps.paidsearchkeyword like '%new voice media%'
or ps.paidsearchkeyword like '%+new%'
or ps.paidsearchkeyword like '%+voice%'
or ps.paidsearchkeyword like '%+media%'
or ps.paidsearchkeyword like '%contact world%' then 'Brand' else 'Nonbrand' end as NonbrandBrand
from default.aprillogsleadsubmissions a
left join dcm.paidsearch ps on a.segmentvalue1 = ps.paidsearchlegacykeywordid and ps.campaignid in (23286358, 23299224, 23383949)
where a.segmentvalue1 is not null and ps.paidsearchlegacykeywordid is not null

);

--MAP OUT CHANNEL TACTIC BY PLACEMENTS
CREATE TABLE AprilPlacementIDAndTactic AS (
SELECT distinct placementid, 
case when placementid in (256670468, 257176446, 256731116, 258669735, 257319514, 258252515, 257165745, 256729799, 256707722, 256725095, 257111178, 256691561, 257135278, 271077772) then 'Search'
when placementid in (270572520, 270217613, 270170330, 270216398, 270169538, 270214196, 270214205, 270170984, 270171197, 270214208, 270216650, 270216635,
270216848, 270214193, 270572982, 270216410, 270216830, 270524262, 270524268, 270217388, 270216845, 270169541, 270473851, 270572997, 270216827, 270572526, 270217382,
270216647, 270522498, 270573003, 270170327, 270572532, 270524865, 270216632, 270572505, 270217361, 270216653, 270216638, 270171200, 270170978, 270217391, 270217616,
270573006, 270214202, 270573015, 270524265, 270216833, 270522501, 270473860) then 'Amobee'
when placementid in (270200985, 270200988, 269857487, 269858102) then 'Hulu'
when placementid in (270548757, 261825245, 270456634, 268999905, 268998786, 268648443, 270733173, 268444473, 262145593, 261832400, 270548745, 270455992, 270726867, 270193508, 270193535,
270456622, 268352075, 270193520, 270732867, 268134428, 268631368, 268134416, 270640270, 268948840, 261825230, 270456628, 270456640, 270733407, 270456019, 268449735, 270457129, 268352108,
270456664, 261825233, 262238967, 262144207, 268633057, 268435602, 268682762, 262144216, 268632562, 270640786, 268998078, 270456649, 262143616, 268145429, 270456370, 270732549, 270548754,
268444467, 270640783, 270457135, 270193529, 270733167, 262144219, 268940053, 270733176, 268649139, 270733707, 261825236, 262238961) then 'Madison Logic'
when placementid in (270216872, 270217637, 270115324, 270573045, 270216677, 270116449, 270217403, 269857502, 270217634, 270214256) then 'Reddit'
when placementid in (270359025, 270359031, 270269005, 270358830, 270359889, 270358842, 270358833, 270000698, 270214259, 270000677, 270358854, 270359019, 270359028, 270359898, 270358836) then 'Simplifi'
when placementid in (258555317, 256528060, 258555290, 258555296, 258555281, 258555299, 256528081, 258555293, 256316423, 258555287, 256528051, 256316417, 256528069, 256528084, 258555272,
256316411, 256528054, 258555269, 256528063, 258555278, 256528072, 258555311, 258555308, 256528078, 256528057, 258555314, 258555284, 256528066) then 'Spiceworks'
when placementid in (269857469, 269857460, 270116146, 270115279) then 'Spotify'
when placementid in (256146151, 256146094, 256147252, 256147276, 256146085, 256147162, 256146124, 256146046, 256146127, 259943568, 256147171, 256146088, 256146061,
256147189, 256284429, 256147168, 256146163, 256146190, 259853479, 256147183, 256147279, 256284468, 256146160, 256146166, 256146049, 256147204, 256284450, 256146145,
256145131, 256146055, 256147180, 256146208, 256147195, 256147177, 256146196, 256147216, 256146142, 255833171, 256146091, 256147198, 256284477, 256146199, 256284459,
256146037, 256284462, 256284438, 256147201, 256284486, 256147207, 256146121, 256146058, 256147219, 256146187, 256146181, 256146130, 256147258, 256146136, 259538996,
256146103, 256147264, 256146172, 256146106, 256146154, 256146133, 256147273, 256147186, 256146205, 256146139, 256284420, 256146220, 256146157, 256146100, 256146178,
256147270, 256146169, 256146052, 256146148, 256145308, 256147210, 256146184, 256146175, 259852936, 259853293, 256147261, 256147267, 256145137, 256147192, 256146202,
256146067, 256147213, 256147282, 256147165, 256146214, 256284447, 256284423, 259538180, 256146193, 256146043, 256146064, 256284471, 255830963, 256147174, 256146097,
256146040, 256145140) then 'The Trade Desk'
when placementid in (262603175, 262598399, 262590143, 262351787, 262598396) then 'Youtube' else 'Unspecified' end as Channel
from default.aprillogsleadsubmissions
where placementid is not null
);

--CREATE MAP BY PLATFORM TACTIC AND FUNNEL TACTIC
CREATE TABLE AprilVonageTacticFunnelMap AS (
select distinct placementid,
case when placementid = 270473860 then 'Amobee Audio'
when placementid in (270217613, 270216650, 270216848, 270216653, 270214202, 270573015) then 'Amobee CTV'
when placementid in (270216398, 270214205, 270214208, 270216635, 270572982, 270216830, 270216827, 270216632, 270572505, 270217361, 270216638, 270217391, 270217616, 270216833) then 'Amobee LinkedIn Audience'
when placementid in (270214193, 270572997, 270217382, 270216647) then 'Amobee OLV'
when placementid in (270170330, 270169538, 270170984, 270171197, 270524262, 270524268, 270169541, 270522498, 270170327, 270524865, 270171200, 270170978, 270524265, 270522501) then 'Amobee Retargeting' 
when placementid in (270572520, 270214196, 270216410, 270217388, 270216845, 270473851, 270572526, 270573003, 270572532, 270573006) then 'Amobee Standard Display'
when placementid = 271077772 then 'Baidu Search' 
when placementid in (270200985, 270200988, 269857487, 269858102) then 'Hulu CTV'
when placementid in (268999905, 268998786, 268648443, 268352075, 268631368, 268948840, 268352108, 268633057, 268682762, 268632562, 268998078, 268940053, 268649139) then 'Madison Logic Prospecting'
when placementid in (270548757, 261825245, 270456634, 270733173, 268444473, 262145593, 261832400, 270548745, 270455992, 270726867, 270193508, 270193535, 270456622,
270193520, 270732867, 268134428, 268134416, 270640270, 261825230, 270456628, 270456640, 270733407, 270456019, 268449735, 270457129, 270456664, 261825233, 262238967,
262144207, 268435602, 262144216, 270640786, 270456649, 262143616, 268145429, 270456370, 270732549, 270548754, 268444467, 270640783, 270457135, 270193529, 270733167,
262144219, 270733176, 270733707, 261825236, 262238961) then 'Madison Logic Retargeting' 
when placementid in (270115324, 269857502) then 'Reddit Community Category Takeover' 
when placementid in (270216872, 270217637, 270573045, 270216677, 270116449, 270217403, 270217634, 270214256) then 'Reddit Promoted Post'
when placementid = 256670468 then 'Search Bing'
when placementid in (257176446, 256731116, 258669735, 257319514, 258252515, 257165745, 256729799, 256707722, 256725095, 257111178, 256691561, 257135278) then 'Search Google'
when placementid in (270359025, 270359031, 270269005, 270358830, 270359889, 270358833, 270214259, 270000677, 270358854, 270359019, 270359028, 270359898, 270358836) then 'Simplifi Addressable Geofence'
when placementid = 270000698 then 'Simplifi Event Targeting'
when placementid = 270358842 then 'Simplifi OOH Geofence'
when placementid in (258555317, 256528081, 256528084, 258555311, 258555308, 256528078, 258555314) then 'Spiceworks Audience Extension'
when placementid in (256528060, 258555290, 258555296, 258555281, 258555299,258555293, 258555287, 256528069, 256528063, 258555278, 256528072, 258555284, 256528066) then 'Spiceworks Group Sponsorship'
when placementid in (256316423, 256316417, 256316411) then 'Spiceworks Native'
when placementid in (256528051, 258555272, 256528054, 258555269, 256528057) then 'Spiceworks Value Add' 
when placementid in (269857460, 270116146, 270115279) then 'Spotify Desktop Headliner'
when placementid = 269857469 then 'Spotify Desktop Overlay'
when placementid in (256284429, 256284477, 256284459, 256284447, 256284423, 256284471, 255830963) then 'The Trade Desk Data Alliance' 
when placementid = 256145308 then 'The Trade Desk Lookalike' 
when placementid in (256145131, 256145137, 256145140) then 'The Trade Desk NY Times'
when placementid in (256146151, 256146094, 256147252, 256147276, 256146085, 256147162, 256146124, 256146046, 256146127, 259943568, 256147171, 256146088, 256146061,
256147189, 256147168, 256146163, 256146190, 259853479, 256147183, 256147279, 256146160, 256146166, 256146049, 256147204, 256146145, 256146055, 256147180, 256146208,
256147195, 256147177, 256146196, 256147216, 256146142, 255833171, 256146091, 256147198, 256146199, 256146037, 256147201, 256147207, 256146121, 256146058, 256147219,
256146187, 256146181, 256146130, 256147258, 256146136, 259538996, 256146103, 256147264, 256146172, 256146106, 256146154, 256146133, 256147273, 256147186, 256146205,
256146139, 256146220, 256146157, 256146100, 256146178, 256147270, 256146169, 256146052, 256146148, 256147210, 256146184, 256146175, 259852936, 259853293, 256147261,
256147267, 256147192, 256146202, 256146067, 256147213, 256147282, 256147165, 256146214, 259538180, 256146193, 256146043, 256146064, 256147174, 256146097, 256146040) then 'The Trade Desk Retargeting'
when placementid in (256284468, 256284450, 256284462, 256284438, 256284486, 256284420) then 'The Trade Desk Time Inc'	
when placementid = 262351787 then 'Youtube Anywhere Communication'
when placementid = 262590143 then 'Youtube Evolving Endline'
when placementid = 262598396 then 'Youtube Its Not For Everyone'
when placementid = 262598399 then 'Youtube The Year Is 1975'
when placementid = 262603175 then 'Youtube Vonage Not Vonage' else 'Unspecified' end as PlatformTactic,
case when placementid in (270200985, 270200988, 270115324, 270358842, 270000698, 269857502, 269857460, 270116146, 270115279) then 'Disrupt'
when placementid in (270216872, 270217637, 270572520, 270217613, 270359025, 270359031, 262603175, 270216398, 270169538, 270214196, 270214205, 270573045, 262598399, 270214208,
270269005, 256284429, 270216650, 269857487, 262590143, 270358830, 270359889, 270216635, 256284468, 270216848, 256284450, 270358833, 270214193, 256145131, 270216677, 262351787,
270116449, 270572982, 270214259, 270216410, 270216830, 270524262, 270524268, 270217388, 269857469, 270217403, 270216845, 270473851, 270572997, 270216827, 270572526, 256284477,
256284459, 256284462, 256284438, 270217382, 270216647, 256284486, 270522498, 270573003, 270572532, 256284420, 270217634, 270216632, 270572505, 270000677, 270217361, 270216653,
270216638, 256145308, 270358854, 269858102, 256145137, 270214256, 270359019, 270359028, 270217391, 270217616, 270573006, 270214202, 270573015, 256284447, 256284423, 270524265,
270216833, 262598396, 270359898, 270358836, 270473860, 256284471, 255830963, 256145140) then 'Introduce'
when placementid in (270548757, 271077772, 270170330, 256146151, 256146094, 256147252, 258555317, 256147276, 256528060, 258555290, 256146085, 261825245, 270456634, 256147162,
268999905, 256146124, 256146046, 256670468, 268998786, 257176446, 268648443, 258555296, 256731116, 270733173, 268444473, 256146127, 259943568, 256147171, 256146088, 262145593,
261832400, 258669735, 270170984, 270171197, 258555281, 256146061, 270548745, 270455992, 256147189, 270726867, 256147168, 270193508, 270193535, 256146163, 257319514, 258252515,
256146190, 258555299, 259853479, 256147183, 256147279, 270456622, 256146160, 268352075, 256146166, 256146049, 256528081, 256147204, 258555293, 270193520, 270732867, 268134428,
268631368, 268134416, 270640270, 268948840, 256146145, 256316423, 258555287, 261825230, 256528051, 270456628, 270456640, 270733407, 256146055, 256147180, 270456019, 256146208,
256147195, 256147177, 256146196, 256147216, 270169541, 256146142, 255833171, 256146091, 268449735, 270457129, 256147198, 256146199, 256146037, 268352108, 270456664, 256147201,
261825233, 262238967, 262144207, 256316417, 256147207, 268633057, 268435602, 256146121, 268682762, 256146058, 262144216, 256528069, 256147219, 256146187, 268632562, 270170327,
256146181, 256146130, 256147258, 256146136, 256528084, 259538996, 258555272, 257165745, 256146103, 270524865, 270640786, 256147264, 256146172, 256316411, 256528054, 258555269,
256146106, 268998078, 256146154, 256146133, 256147273, 256147186, 256528063, 256729799, 270456649, 256146205, 258555278, 256146139, 256528072, 256146220, 258555311, 256146157,
256146100, 262143616, 256146178, 268145429, 258555308, 256528078, 256147270, 256146169, 256707722, 270456370, 270171200, 270732549, 256146052, 256146148, 256147210, 256725095,
270548754, 270170978, 268444467, 256146184, 270640783, 270457135, 256146175, 259852936, 259853293, 256147261, 256528057, 257111178, 256691561, 270193529, 270733167, 256147267,
258555314, 262144219, 256147192, 256146202, 268940053, 270733176, 256146067, 258555284, 256147213, 257135278, 256147282, 256147165, 256146214, 259538180, 268649139, 270733707,
256146193, 261825236, 256146043, 262238961, 256528066, 270522501, 256146064, 256147174, 256146097, 256146040) then 'Substantiate' else 'Unspecified' end as FunnelStage
from default.aprillogsleadsubmissions
where placementid is not null
);

--JOIN THE TWO MAPPING FILES TO THE LOGS TO CREATE THE MASTER RAW DATA WE NEED
CREATE TABLE AprilLeadSubmissionsMapped AS
(
select l.*, m.nonbrandbrand, t.channel, v.platformtactic, v.funnelstage,
case when l.placementid in (271077772, 256731116, 256729799) then 'APAC' 
when l.placementid in (257176446, 256725095, 258669735) then 'EMEA'
when l.placementid in (257319514, 257165745, 257135278) then 'Global' else 'US' end as Region
from default.aprillogsleadsubmissions l
left join default.aprilsearchkeywordmap m on l.segmentvalue1 = m.paidsearchlegacykeywordid
left join default.aprilplacementidandtactic t on l.placementid = t.placementid
left join default.aprilvonagetacticfunnelmap v on l.placementid = v.placementid
where userid <> '0'
);

--CREATE THE RAW TABLE WITH ALL INFORMATION WE NEED
CREATE TABLE AprilLeadSubmissionsUsersAndConversions AS
(
select userid, eventdatetime, activeviewmeasurableimpressions, activevieweligibleimpressions, activeviewviewableimpressions,
case when nonbrandbrand in ('Brand', 'Nonbrand') then concat(channel, ' ', nonbrandbrand)
when nonbrandbrand is null and channel = 'Search' then concat(channel, ' ', 'Nonbrand') else channel end as Channel,
case when eventtype = 'VIEW' and eventsubtype = 'VIEW' then 1 else 0 end as Impression,
case when eventtype = 'CLICK' and eventsubtype = 'CLICK' then 1 else 0 end as Click, 
case when eventtype = 'CONVERSION' and eventsubtype = 'POSTCLICK' then 1 else 0 end as ClickthroughConversion,
case when eventtype = 'CONVERSION' and eventsubtype = 'POSTVIEW' then 1 else 0 end as ViewthroughConversion
from default.aprilleadsubmissionsmapped
where region = 'US'
);

--SELECT BASIC STATS & DCM LAST TOUCH CONVERSIONS (PLATFORM, # OF USERS, TOTAL LEADS)
select channel, count(distinct userid) as noofusers, sum(clickthroughconversion + viewthroughconversion) as totalconversion
from default.aprilleadsubmissionsusersandconversions
group by channel

--------BEGIN SETUP OF DATA FOR MTA ANALYSIS----------------------------------------------------------------------------------------------------

--CREATE TABLE FOR TOTAL CONVERSIONS BY USER, EVENTDATETIME AND CHANNEL (DROPPING THE TRADE DESK & YOUTUBE SINCE IT WAS DISCONTINUED)
CREATE TABLE AprilLeadSubmissionsTotalConversions AS
(
select userid, eventdatetime, channel, sum(impression) as impression, sum(click) as click, sum(clickthroughconversion + viewthroughconversion) as totalconversions
from default.AprilLeadSubmissionsUsersAndConversions
group by userid, eventdatetime, channel
  );

--EXPAND UPON TABLE ABOVE BY ADDING IN NULL CONVERSIONS
CREATE TABLE AprilLeadSubmissionsTotalConversionsAndNulls AS
(
select userid, eventdatetime, channel, totalconversions, impression, click, case when totalconversions > 0 then 0 else 1 end as nullconversions 
from default.AprilLeadSubmissionsTotalConversions
  );
  
--TABLE FOR USERS, IMPRESSIONS AND CONVERSIONS GROUPED BY USERS TO SEE ALL INTERACTIONS BY USER
CREATE TABLE AprilLeadSubmissionsUserAggregatedMetrics AS 
(
select userid, sum(impression) as impression, sum(click) as click, sum(totalconversions) as totalconversions, sum(nullconversions) as nullconversions
from default.aprilleadsubmissionstotalconversionsandnulls
group by userid
);

--COLLAPSE CHANNELS AND GROUP BY USERIDS TO GENERATE FULL CHANNEL PATH, FIRST TOUCH DATE, LAST TOUCH DATE, CONVERSIONS AND NONCONVERSIONS FOR EACH USER
CREATE TABLE AprilLeadSubmissionsChannelsCollapsed AS 
(
select userid, array_join(array_agg(channel order by eventdatetime asc), ' > ') as channelflow, min(eventdatetime) as firsttouch, max(eventdatetime) as lasttouch, sum(totalconversions) as totalconversions, sum(nullconversions) as nullconversions
from default.aprilleadsubmissionstotalconversionsandnulls
group by userid
);

--SELECT CONVERSIONS AND NULL CONVERSIONS AND THEN DOWNLOAD OUTPUT FOR THE MARKOV CHAIN ATTRIBUTION ANALYSIS 
select channelflow, sum(totalconversions) as totalconversions, sum(nullconversions) as nullconversions
from default.aprilleadsubmissionschannelscollapsed
group by channelflow

CREATE TABLE AprilLeadSubmissionsUserAggregatedMetrics AS 
(
select userid, sum(impression) as impression, sum(click) as click, sum(totalconversions) as totalconversions, sum(nullconversions) as nullconversions
from default.aprilleadsubmissionstotalconversionsandnulls
group by userid
);

-------------END OF MTA ANALYSIS DATA SETUP-----------------------------------------------------------------------------------------------

-------------BEGIN ADDITIONAL ANALYSIS AVAILABLE FROM LOG DATA----------------------------------------------------------------------------

--SELECT COUNT OF UNIQUE USERS AND ALL METRIC VALUES GROUPED BY IMPRESSION TO UNDERSTAND CONVERSIONS, CLICKS AND NONCONVERSIONS AT EACH IMPRESSION FREQUENCY
select impression, count(distinct userid) as uniqueusers, sum(click) as click, sum(totalconversions) as totalconversions, sum(nullconversions) as nullconversions
from default.aprilleadsubmissionsuseraggregatedmetrics
group by impression

select userid, totalconversions, impression
from default.aprilleadsubmissionsuseraggregatedmetrics

--SELECT USERS THAT CONVERTED AT LEAST ONCE AND SEE HOW MUCH TIME ELAPSED BETWEEN THEIR FIRST AND LAST INTERACTION
select *, date_diff('day', firsttouch, lasttouch) as totaltimelapsed
from default.aprilleadsubmissionschannelscollapsed
where totalconversions > 0

--SELECT CONVERSIONS AND IMPRESSIONS GROUPED BY USERID TO SEE OPTIMAL FREQUENCY

CREATE TABLE AprilOptimalFrequencyConversions AS 
(
select userid, sum(totalconversions) as totalconversions
from default.aprilleadsubmissionstotalconversions
group by userid
  );

CREATE TABLE AprilOptimalFrequencyImpression AS 
(
select userid, sum(impression) as impression
from default.aprilleadsubmissionstotalconversions
group by userid
  );

--LEFT JOIN THE TWO TABLES ABOVE FOR A DOWNLOADABLE OPTIMAL FREQUENCY DATA FILE  
select c.*, i.impression
from default.apriloptimalfrequencyconversions c 
left join default.apriloptimalfrequencyimpression i on c.userid = i.userid
where totalconversions > 0 

select c.*, i.impression, cc.nullconversions 
from default.apriloptimalfrequencyconversions c 
left join default.apriloptimalfrequencyimpression i on c.userid = i.userid
left join default.aprilleadsubmissionschannelscollapsed cc on c.userid = cc.userid

--COUNTING IMPRESSIONS, CLICKS AND CONVERSIONS BY PLATFORM--
CREATE TABLE AprilLeadSubmissionsUserActivity AS 
(
select userid, 
case when channel = 'Search' and nonbrandbrand = 'Brand' then coalesce(count(distinct eventdatetime), 0) else 0 end as Search_Brand,
case when channel = 'Search' and nonbrandbrand = 'Nonbrand' then coalesce(count(distinct eventdatetime), 0)
when channel = 'Search' and nonbrandbrand is null then coalesce(count(distinct eventdatetime), 0) else 0 end as Search_Nonbrand,
case when channel = 'Madison Logic' then coalesce(count(distinct eventdatetime), 0) else 0 end as Madison_Logic,
case when channel = 'Reddit' then coalesce(count(distinct eventdatetime), 0) else 0 end as Reddit,
case when channel = 'Amobee' then coalesce(count(distinct eventdatetime), 0) else 0 end as Amobee,
case when channel = 'Hulu' then coalesce(count(distinct eventdatetime), 0) else 0 end as Hulu,
case when channel = 'Simplifi' then coalesce(count(distinct eventdatetime), 0) else 0 end as Simplifi,
case when channel = 'Spiceworks' then coalesce(count(distinct eventdatetime), 0) else 0 end as Spiceworks,
case when channel = 'Spotify' then coalesce(count(distinct eventdatetime), 0) else 0 end as Spotify,
case when eventtype = 'CONVERSION' then coalesce(count(distinct eventdatetime), 0) else 0 end as Conversion,
case when eventtype = 'VIEW' then coalesce(count(distinct eventdatetime), 0) else 0 end as View,
case when eventtype = 'CLICK' then coalesce(count(distinct eventdatetime), 0) else 0 end as Click
from default.aprilleadsubmissionsmapped
where region = 'US'
group by userid, nonbrandbrand, channel, eventtype
);

--AGGREGATE ALL MEDIA INTERACTIONS AT THE USER LEVEL--
CREATE TABLE AprilLeadSubmissionsUsersMerged AS
(
select userid, 
sum(search_brand) as search_brand,
sum(search_nonbrand) as search_nonbrand,
sum(madison_logic) as madison_logic,
sum(reddit) as reddit,
sum(amobee) as amobee,
sum(hulu) as hulu,
sum(simplifi) as simplifi,
sum(spiceworks) as spiceworks,
sum(spotify) as spotify,
sum(conversion) as conversion,
sum(view) as view,
sum(click) as click
from default.aprilleadsubmissionsuseractivity
group by userid
);

--CREATE FLAGS TO ISOLATE SEARCH FROM NON SEARCH PLATFORMS--
CREATE TABLE AprilLeadSubmissionsPaidSearchCombos AS (
select *,
case when search_brand = 0 and search_nonbrand = 0 and (madison_logic >= 1 or reddit >= 1 or amobee >= 1 or hulu >= 1 or simplifi >= 1 or spiceworks >= 1 or spotify >= 1) then 'Non Search Channels'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search'
when search_brand >= 1 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search'
when (search_brand >= 1 or search_nonbrand >= 1) and (madison_logic >= 1 or reddit >= 1 or amobee >= 1 or hulu >= 1 or simplifi >= 1 or spiceworks >= 1 or spotify >= 1) then 'Assisted Search' else 'Error' end as usermediamix
from default.aprilleadsubmissionsusersmerged
);

--SELECT TOTAL # OF USERS AND CONVERSIONS BY MEDIA MIX
select usermediamix, count(distinct userid) as noofusers, sum(click) as click, sum(conversion) as totalconversions
from default.aprilleadsubmissionspaidsearchcombos
group by usermediamix


--CREATE FLAGS FOR TWO CHANNEL COMBOS CONTAINING PAID SEARCH--
CREATE TABLE AprilLeadSubmissionsPaidSearchTwoChannelCombo AS 
(
select *,
case when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'No Media Interaction'
--1 channel
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Brand'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand'
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Madison Logic'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit >= 1 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Reddit'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee >= 1 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Amobee'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu >= 1 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Hulu'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi >= 1 and spiceworks = 0 and spotify = 0 then 'Simplifi'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks >= 1 and spotify = 0 then 'Spiceworks'
when search_brand = 0 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify >= 1 then 'Spotify'
--2 channel search brand
when search_brand >= 1 and search_nonbrand = 0 and madison_logic >= 1 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Brand & Madison Logic'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit >= 1 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Brand & Reddit'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee >= 1 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Brand & Amobee'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu >= 1 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Brand & Hulu'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi >= 1 and spiceworks = 0 and spotify = 0 then 'Search Brand & Simplifi'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks >= 1 and spotify = 0 then 'Search Brand & Spiceworks'
when search_brand >= 1 and search_nonbrand = 0 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify >= 1 then 'Search Brand & Spotify'
--2 channel search nonbrand
when search_brand = 0 and search_nonbrand >= 1 and madison_logic >= 1 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand & Madison Logic'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit >= 1 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand & Reddit'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee >= 1 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand & Amobee'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu >= 1 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand & Hulu'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi >= 1 and spiceworks = 0 and spotify = 0 then 'Search Nonbrand & Simplifi'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks >= 1 and spotify = 0 then 'Search Nonbrand & Spiceworks'
when search_brand = 0 and search_nonbrand >= 1 and madison_logic = 0 and reddit = 0 and amobee = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify >= 1 then 'Search Nonbrand & Spotify'
--2 channel amobee
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic >= 1 and reddit = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Amobee & Madison Logic'
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic = 0 and reddit >= 1 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Amobee & Reddit'
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic = 0 and reddit = 0 and hulu >= 1 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Amobee & Hulu'
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic = 0 and reddit = 0 and hulu = 0 and simplifi >= 1 and spiceworks = 0 and spotify = 0 then 'Amobee & Simplifi'
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic = 0 and reddit = 0 and hulu = 0 and simplifi = 0 and spiceworks >= 1 and spotify = 0 then 'Amobee & Spiceworks'
when search_brand = 0 and search_nonbrand = 0 and amobee >= 1 and madison_logic = 0 and reddit = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify >= 1 then 'Amobee & Spotify'
--2 channel madison logic
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and amobee = 0 and reddit >= 1 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Madison Logic & Reddit'
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and amobee = 0 and reddit = 0 and hulu >= 1 and simplifi = 0 and spiceworks = 0 and spotify = 0 then 'Madison Logic & Hulu'
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and amobee = 0 and reddit = 0 and hulu = 0 and simplifi >= 1 and spiceworks = 0 and spotify = 0 then 'Madison Logic & Simplifi'
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and amobee = 0 and reddit = 0 and hulu = 0 and simplifi = 0 and spiceworks >= 1 and spotify = 0 then 'Madison Logic & Spiceworks'
when search_brand = 0 and search_nonbrand = 0 and madison_logic >= 1 and amobee = 0 and reddit = 0 and hulu = 0 and simplifi = 0 and spiceworks = 0 and spotify >= 1 then 'Madison Logic & Spotify'
else 'Other Mixes' end as usermediamix
from default.aprilleadsubmissionsusersmerged
);

--SELECT # OF UNIQUE USERS AND TOTAL CONVERSIONS FOR EACH MEDIA MIX GROUP
select usermediamix, count(distinct userid) as noofusers, sum(conversion) as convertedusers
from default.AprilLeadSubmissionsPaidSearchTwoChannelCombo
group by usermediamix

--BUCKET TOUCHES BY THE TWO CHANNEL COMBOS FOR CONVERSIONS GREATER EQUAL TO 1
CREATE TABLE AprilLeadSubmissionsTwoChannelConvertedTouches AS 
(
select usermediamix,
count(distinct userid) as numberofuniqueusers,
sum(search_brand) as search_brand,
sum(search_nonbrand) as search_nonbrand,
sum(madison_logic) as madison_logic,
sum(reddit) as reddit,
sum(amobee) as amobee,
sum(hulu) as hulu,
sum(simplifi) as simplifi,
sum(spiceworks) as spiceworks,
sum(spotify) as spotify,
sum(conversion) as conversion,
sum(view) as view,
sum(click) as click
from default.aprilleadsubmissionspaidsearchtwochannelcombo
where conversion >= 1
group by usermediamix
);