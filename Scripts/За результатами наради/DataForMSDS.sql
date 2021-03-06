select m.MatName as IDnumber
	, isnull(m.CASNumber,'n/a') as CASnumber 
	, case when m.MDLNumber is null then '' else  m.MDLNumber end  as MDLnumber 
	, m.Brutto_Formula_with_Salt as Formula
	, m.IUPAC_Name as ChemName
	, round(m.MW_with_Salt,2) as MW
	, isnull(x.Appearance,'n/a') as Appearance
	, isnull(cast(y.MeltingPoint as varchar(32)),'n/a') as MeltingPoint
from dbo._tmp_ID_list l 
	inner join Materials m on m.MatName = l.IDNUMBER
	left join (	select s.ID, MAX(s.Комментарии) as Appearance 
				from tblСпектр s 
				where s.Тип_спектра_Код = 11			-- A 
					and s.Результат = 'OK' 
					and s.Комментарии is not null 
				group by s.ID
				)x on x.ID = l.IDNUMBER
	left join (	select s.ID, max(s.[Процентное содержание]) as MeltingPoint
				from tblСпектр s 
				where s.Тип_спектра_Код = 3				-- T 
					and s.Результат = 'OK' 
					and s.[Процентное содержание] is not null 
				group by s.ID
				)y on y.ID = l.IDNUMBER	
--where m.MatName in ('F0777-0781','F0880-0042')				
where m.IUPAC_Name like '%?%' --  is null				
--select * from tblТипы_спектров	

/*
update Materials set IUPAC_Name = N'I-hydroxy-4-methyl-I-phenylbenzene-1-sulfonoperoxoyl iodide' where MatName = 'F0001-0883'
update Materials set IUPAC_Name = N'3-fluoro-4-methoxypyrrolidine hydrochloride' where MatName = 'F1900-3494'
update Materials set IUPAC_Name = N'N1-[4-methyl-6-(pyrrolidin-1-yl)pyrimidin-2-yl]benzene-1,4-diamine' where MatName = 'F1910-8003'
update Materials set IUPAC_Name = N'6-chloro-2-(1,4-diazepan-1-yl)-1,3-benzothiazole dihydrochloride' where MatName = 'F1913-0936'
update Materials set IUPAC_Name = N'2-{6-methyl-5-oxo-2H,3H,5H-[1,3]thiazolo[3,2-a]pyrimidin-3-yl}acetic acid hydrobromide' where MatName = 'F2135-1220'
update Materials set IUPAC_Name = N'2-methoxycyclopropan-1-amine hydrochloride' where MatName = 'F2147-3898'
update Materials set IUPAC_Name = N'3-(azetidin-3-yl)-1,3-oxazolidin-2-one; trifluoroacetic acid' where MatName = 'F2147-9873'
update Materials set IUPAC_Name = N'3-methyl-5H,6H,7H,8H-imidazo[1,5-a]pyridine-1-carboxylic acid hydrochloride' where MatName = 'F2147-9880'
update Materials set IUPAC_Name = N'1-(3,4-dihydro-1H-2-benzopyran-3-yl)methanamine hydrochloride' where MatName = 'F2147-9881'
update Materials set IUPAC_Name = N'3-bromo-5-fluoro-[1,1''-biphenyl]-4-carbaldehyde' where MatName = 'F2173-1452'
update Materials set IUPAC_Name = N'3-bromo-4-methoxythiophene' where MatName = 'F2184-0274'
update Materials set IUPAC_Name = N'5-(chloromethyl)-1,3-thiazole hydrochloride' where MatName = 'F2184-0278'
update Materials set IUPAC_Name = N'(3aR,6S,7S,7aS)-2,2,5'',5''-tetramethyl-tetrahydro-2H-spiro[[1,3]dioxolo[4,5-c]pyran-6,2''-[1,4]dioxolan]-7-ol' where MatName = 'F2197-4548'
update Materials set IUPAC_Name = N'[(1R,2S,6S,9R)-4,4,11,11-tetramethyl-3,5,7,10,12-pentaoxatricyclo[7.3.0.0²,⁶]dodecan-6-yl]methanol' where MatName = 'F2197-4550'
update Materials set IUPAC_Name = N'bis(1-(pyrrolidin-3-yl)azetidin-3-ol) trihydrochloride' where MatName = 'F2197-4642'

select IUPAC_Name from Materials where MatName = 'F2197-4548'
select IUPAC_Name from Materials where MatName = 'F2197-4550'
*/

/*
-- UTF-8
select m.MatName as IDnumber
	, cast( isnull(m.CASNumber,'n/a') as nvarchar(10)) as CASnumber 
	, cast(case when m.MDLNumber is null then '' else  m.MDLNumber end as nvarchar(20))  as MDLnumber 
	, cast(m.Brutto_Formula_with_Salt as nvarchar(255)) as Formula
	, m.IUPAC_Name as ChemName
	, cast(round(m.MW_with_Salt,2) as nvarchar(32)) as MW
	, cast(isnull(x.Appearance,'n/a') as nvarchar(128)) as Appearance
	, cast(isnull(cast(y.MeltingPoint as varchar(32)),'n/a') as nvarchar(32)) as MeltingPoint
from dbo._tmp_ID_list l 
	inner join Materials m on m.MatName = l.IDNUMBER
	left join (	select s.ID, MAX(s.Комментарии) as Appearance 
				from tblСпектр s 
				where s.Тип_спектра_Код = 11			-- A 
					and s.Результат = 'OK' 
					and s.Комментарии is not null 
				group by s.ID
				)x on x.ID = l.IDNUMBER
	left join (	select s.ID, max(s.[Процентное содержание]) as MeltingPoint
				from tblСпектр s 
				where s.Тип_спектра_Код = 3				-- T 
					and s.Результат = 'OK' 
					and s.[Процентное содержание] is not null 
				group by s.ID
				)y on y.ID = l.IDNUMBER	
--where m.MatName in ('F0777-0781','F0880-0042', 'F2197-4550')				
			
			*/
/*
update Materials set IUPAC_Name = N'1,2λ⁶-oxathiolane-2,2-dione' where MatName = 'F0001-0265'
update Materials set IUPAC_Name = N'(1H-1,2,3-benzotriazol-1-yloxy)tris(pyrrolidin-1-yl)phosphanium; hexafluoro-λ⁵-phosphanuide' where MatName = 'F0001-0399'
update Materials set IUPAC_Name = N'[(dimethylamino)({3H-[1,2,3]triazolo[4,5-b]pyridin-3-yloxy})methylidene]dimethylazanium; hexafluoro-λ⁵-phosphanuide' where MatName = 'F0001-0528'
update Materials set IUPAC_Name = N'1,2λ⁶-oxathiane-2,2-dione' where MatName = 'F0001-0588'
update Materials set IUPAC_Name = N'trimethyl(oxo)-λ⁶-sulfanylium iodide' where MatName = 'F0001-0645'
update Materials set IUPAC_Name = N'bis(4-methoxyphenyl)-1,3,2λ⁵,4λ⁵-dithiadiphosphetane-2,4-dithione' where MatName = 'F0001-0690'
update Materials set IUPAC_Name = N'methyl 2-(triphenyl-λ⁵-phosphanylidene)acetate' where MatName = 'F0001-0864'
update Materials set IUPAC_Name = N'diethyl(trifluoro-λ⁴-sulfanyl)amine' where MatName = 'F0001-1088'
update Materials set IUPAC_Name = N'(1H-1,2,3-benzotriazol-1-yloxy)tris(dimethylamino)phosphanium; hexafluoro-λ⁵-phosphanuide' where MatName = 'F0001-1485'
update Materials set IUPAC_Name = N'9-oxatricyclo[9.4.0.0²,⁷]pentadeca-1(11),2(7),3,5,12,14-hexaene-8,10-dione' where MatName = 'F0001-1586'
update Materials set IUPAC_Name = N'tripropyl-1,3,5,2λ⁵,4λ⁵,6λ⁵-trioxatriphosphinane-2,4,6-trione' where MatName = 'F0001-1795'
update Materials set IUPAC_Name = N'tricyclo[5.2.1.0²,⁶]deca-3,8-diene' where MatName = 'F0001-1975'
update Materials set IUPAC_Name = N'2,3-dihydro-1λ⁶,2-benzothiazole-1,1,3-trione' where MatName = 'F0001-2092'
update Materials set IUPAC_Name = N'3-oxatricyclo[7.3.1.0⁵,¹³]trideca-1(13),5,7,9,11-pentaene-2,4-dione' where MatName = 'F0001-2093'
update Materials set IUPAC_Name = N'tetracyclo[7.7.1.0²,⁷.0¹³,¹⁷]heptadeca-1(16),2,4,6,9(17),10,12,14-octaen-8-one' where MatName = 'F0001-2103'
update Materials set IUPAC_Name = N'sodium 1,1,3-trioxo-2,3-dihydro-1λ⁶,2-benzothiazol-2-ide hydrate' where MatName = 'F0001-2111'
update Materials set IUPAC_Name = N'1,1-bis(acetyloxy)-3-oxo-3H-1λ⁵,2-benziodaoxol-1-yl acetate' where MatName = 'F0001-2178'
update Materials set IUPAC_Name = N'5,11-dioxatricyclo[7.3.0.0³,⁷]dodeca-1,3(7),8-triene-4,6,10,12-tetrone' where MatName = 'F0001-2194'
update Materials set IUPAC_Name = N'3-(4-hydroxyphenyl)-3-azatricyclo[7.3.1.0⁵,¹³]trideca-1(13),5,7,9,11-pentaene-2,4-dione' where MatName = 'F0013-1087'
update Materials set IUPAC_Name = N'2-butyl-9-chloro-2-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(11),4,6,8(12),9-pentaen-3-one' where MatName = 'F0213-0037'
update Materials set IUPAC_Name = N'3-[2-(piperazin-1-yl)ethyl]-3-azatricyclo[7.3.1.0⁵,¹³]trideca-1(12),5,7,9(13),10-pentaene-2,4-dione' where MatName = 'F0223-0042'
update Materials set IUPAC_Name = N'10-ethyl-12-hydrazinyl-7-thia-9,11-diazatricyclo[6.4.0.0²,⁶]dodeca-1(8),2(6),9,11-tetraene' where MatName = 'F0239-0234'
update Materials set IUPAC_Name = N'4-methyl-5,12-dithia-3-azatricyclo[7.3.0.0²,⁶]dodeca-1(9),2(6),3,7,10-pentaen-8-ol' where MatName = 'F0239-0260'
update Materials set IUPAC_Name = N'5-methyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),5-trien-3-one' where MatName = 'F0239-0687'
update Materials set IUPAC_Name = N'7-thia-9,11-diazatricyclo[6.4.0.0²,⁶]dodeca-1(8),2(6),9-trien-12-one' where MatName = 'F0239-1012'
update Materials set IUPAC_Name = N'12-chloro-10-ethyl-7-thia-9,11-diazatricyclo[6.4.0.0²,⁶]dodeca-1(8),2(6),9,11-tetraene' where MatName = 'F0239-1060'
update Materials set IUPAC_Name = N'14-bromotetracyclo[7.7.1.0²,⁷.0¹³,¹⁷]heptadeca-1(17),2(7),3,5,9,11,13,15-octaen-8-one' where MatName = 'F0266-1973'
update Materials set IUPAC_Name = N'3-[(4-methylphenyl)amino]-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F0273-0023'
update Materials set IUPAC_Name = N'3-chloro-5-methyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F0307-0219'
update Materials set IUPAC_Name = N'2-(1,1,3-trioxo-2,3-dihydro-1λ⁶,2-benzothiazol-2-yl)acetic acid' where MatName = 'F0346-4163'
update Materials set IUPAC_Name = N'8-bromo-3-(2-hydroxyethyl)-3-azatricyclo[7.3.1.0⁵,¹³]trideca-1(12),5,7,9(13),10-pentaene-2,4-dione' where MatName = 'F0346-4805'
update Materials set IUPAC_Name = N'2,5,7-triazatricyclo[6.4.0.0²,⁶]dodeca-1(8),6,9,11-tetraene' where MatName = 'F0451-0657'
update Materials set IUPAC_Name = N'2-ethyl-2-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(11),4(12),5,7,9-pentaen-3-one' where MatName = 'F0472-0224'
update Materials set IUPAC_Name = N'2,5-dimethyl-2,3,4,5-tetrahydro-1λ⁶,5-benzothiazepine-1,1,4-trione' where MatName = 'F0681-0076'
update Materials set IUPAC_Name = N'3-hydrazinyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F0722-0803'
update Materials set IUPAC_Name = N'3-hydrazinyl-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F0734-0031'
update Materials set IUPAC_Name = N'11-methyl-3,10-dithia-5,12-diazatricyclo[7.3.0.0²,⁶]dodeca-1(9),2(6),4,7,11-pentaen-4-amine' where MatName = 'F0737-0222'
update Materials set IUPAC_Name = N'12-chloro-7-thia-9,11-diazatricyclo[6.4.0.0²,⁶]dodeca-1(8),2(6),9,11-tetraene' where MatName = 'F0745-0159'
update Materials set IUPAC_Name = N'3H-2,1λ⁶-benzoxathiole-1,1,3-trione' where MatName = 'F0777-0781'
update Materials set IUPAC_Name = N'3-amino-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F0802-0039'
update Materials set IUPAC_Name = N'11-(methylsulfanyl)-3,12-dithia-5,10-diazatricyclo[7.3.0.0²,⁶]dodeca-1(9),2(6),4,7,10-pentaen-4-amine' where MatName = 'F0817-0083'
update Materials set IUPAC_Name = N'4-(prop-2-en-1-yl)-5-sulfanylidene-8-thia-4,6-diazatricyclo[7.5.0.0²,⁷]tetradeca-1(9),2(7)-dien-3-one' where MatName = 'F0825-0486'
update Materials set IUPAC_Name = N'2-{3,5-dioxo-4-azatricyclo[5.2.1.0²,⁶]dec-8-en-4-yl}-4-methylpentanoic acid' where MatName = 'F0827-0029'
update Materials set IUPAC_Name = N'7-thia-2,5-diazatricyclo[6.4.0.0²,⁶]dodeca-1(12),5,8,10-tetraen-11-amine' where MatName = 'F0850-6728'
update Materials set IUPAC_Name = N'2-{2,4-dioxo-3-azatricyclo[7.3.1.0⁵,¹³]trideca-1(13),5,7,9,11-pentaen-3-yl}acetic acid hydrate' where MatName = 'F0863-0647'
update Materials set IUPAC_Name = N'3-bromo-4-hydroxy-1λ⁶-thiolane-1,1-dione' where MatName = 'F0880-0042'
update Materials set IUPAC_Name = N'3-(1,1,3-trioxo-2,3-dihydro-1λ⁶,2-benzothiazol-2-yl)propanoic acid' where MatName = 'F0900-3328'
update Materials set IUPAC_Name = N'3-chloro-11-methyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F0918-2030'
update Materials set IUPAC_Name = N'6-methoxy-9-methyl-8-oxa-10,12-diazatricyclo[7.3.1.0²,⁷]trideca-2,4,6-triene-11-thione' where MatName = 'F0919-6607'
update Materials set IUPAC_Name = N'3,3-bis(4-hydroxy-3-methylphenyl)-3H-2,1λ⁶-benzoxathiole-1,1-dione' where MatName = 'F0919-7560'
update Materials set IUPAC_Name = N'3-bromo-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1028-0007'
update Materials set IUPAC_Name = N'2-ethyl-3-oxo-2-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(11),4,6,8(12),9-pentaene-9-sulfonyl chloride' where MatName = 'F1061-0020'
update Materials set IUPAC_Name = N'3,4-diamino-1λ⁶-thiolane-1,1-dione dihydrochloride' where MatName = 'F1068-0028'
update Materials set IUPAC_Name = N'2-[(4-hydroxy-1,1-dioxo-1λ⁶-thiolan-3-yl)amino]acetic acid' where MatName = 'F1068-0096'
update Materials set IUPAC_Name = N'3-[(2-hydroxyethyl)amino]-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F1068-0115'
update Materials set IUPAC_Name = N'3-[(2-aminoethyl)amino]-1λ⁶-thiolane-1,1-dione dihydrochloride' where MatName = 'F1068-0119'
update Materials set IUPAC_Name = N'1,1-dioxo-1λ⁶-thiolane-3-sulfonyl chloride' where MatName = 'F1068-1325'
update Materials set IUPAC_Name = N'7-bromo-3-oxatricyclo[7.3.1.0⁵,¹³]trideca-1(13),5,7,9,11-pentaene-2,4-dione' where MatName = 'F1113-0420'
update Materials set IUPAC_Name = N'2-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(12),4,6,8,10-pentaen-3-one' where MatName = 'F1113-0546'
update Materials set IUPAC_Name = N'3-chloro-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F1126-0518'
update Materials set IUPAC_Name = N'11-methyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),5-trien-3-one' where MatName = 'F1142-3898'
update Materials set IUPAC_Name = N'4,10-dithia-6,12-diazatricyclo[7.3.0.0³,⁷]dodeca-1,3(7),5,8,11-pentaene-5,11-diamine' where MatName = 'F1217-0008'
update Materials set IUPAC_Name = N'4-amino-6,7-dimethyl-4-azatricyclo[4.3.0.0³,⁷]nonane-3-carboxamide' where MatName = 'F1244-0156'
update Materials set IUPAC_Name = N'5-chloro-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1294-0009'
update Materials set IUPAC_Name = N'2,5-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1294-0012'
update Materials set IUPAC_Name = N'3-hydroxy-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1294-0014'
update Materials set IUPAC_Name = N'6-oxa-3λ⁶-thiabicyclo[3.1.0]hexane-3,3-dione' where MatName = 'F1294-0015'
update Materials set IUPAC_Name = N'3-chloro-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0024'
update Materials set IUPAC_Name = N'3-bromo-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0026'
update Materials set IUPAC_Name = N'1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0027'
update Materials set IUPAC_Name = N'3-sulfanyl-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0028'
update Materials set IUPAC_Name = N'3-hydroxy-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0029'
update Materials set IUPAC_Name = N'3-amino-2,3-dihydro-1λ⁶-thiophene-1,1-dione hydrochloride' where MatName = 'F1294-0034'
update Materials set IUPAC_Name = N'1,1-dioxo-1λ⁶-thiolane-3-sulfonamide' where MatName = 'F1294-0037'
update Materials set IUPAC_Name = N'3-isocyanato-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1294-0050'
update Materials set IUPAC_Name = N'3-isothiocyanato-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0053'
update Materials set IUPAC_Name = N'1,1-dioxo-1λ⁶-thiolan-3-yl carbonochloridate' where MatName = 'F1294-0056'
update Materials set IUPAC_Name = N'3-(methylamino)-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0076'
update Materials set IUPAC_Name = N'3-(aminomethyl)-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0077'
update Materials set IUPAC_Name = N'3-(aminomethyl)-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F1294-0083'
update Materials set IUPAC_Name = N'3-(isothiocyanatomethyl)-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0094'
update Materials set IUPAC_Name = N'2-[(1,1-dioxo-1λ⁶-thiolan-3-yl)amino]acetic acid' where MatName = 'F1294-0114'
update Materials set IUPAC_Name = N'3-(2-hydroxyethoxy)-1λ⁶-thiolane-1,1-dione' where MatName = 'F1294-0120'
update Materials set IUPAC_Name = N'3-isothiocyanato-2,5-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1295-0001'
update Materials set IUPAC_Name = N'{8-thiatricyclo[7.4.0.0²,⁷]trideca-1(13),2(7),3,5,9,11-hexaen-4-yl}boronic acid' where MatName = 'F1371-0134'
update Materials set IUPAC_Name = N'5-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(12),8,10-trien-2-one' where MatName = 'F1371-0138'
update Materials set IUPAC_Name = N'3-[(3-chlorophenyl)amino]-2,3-dihydro-1λ⁶-thiophene-1,1-dione' where MatName = 'F1745-0001'
update Materials set IUPAC_Name = N'4-azatricyclo[5.2.1.0²,⁶]dec-8-en-3-one' where MatName = 'F1900-3875'
update Materials set IUPAC_Name = N'1,1-dioxo-2,5-dihydro-1λ⁶-thiophene-3-carboxylic acid' where MatName = 'F1900-9603'
update Materials set IUPAC_Name = N'6-hydroxy-1-azatricyclo[7.3.1.0⁵,¹³]trideca-5,7,9(13)-triene-7-carbaldehyde' where MatName = 'F1901-0142'
update Materials set IUPAC_Name = N'4-(hydroxymethyl)-1λ⁶-thiane-1,1-dione' where MatName = 'F1905-0514'
update Materials set IUPAC_Name = N'2,3-dihydro-1λ⁶,2-benzothiazole-1,1-dione' where MatName = 'F1905-7319'
update Materials set IUPAC_Name = N'tricyclo[9.4.0.0³,⁸]pentadeca-1(11),3,5,7,12,14-hexaen-9-one' where MatName = 'F1905-8603'
update Materials set IUPAC_Name = N'1,8,10-triazatricyclo[7.4.0.0²,⁷]trideca-2(7),3,5,8,12-pentaen-11-one' where MatName = 'F1905-8719'
update Materials set IUPAC_Name = N'1H,3H,4H-2λ⁶-thieno[3,2-c][1,2]thiazine-2,2,4-trione' where MatName = 'F1907-0580'
update Materials set IUPAC_Name = N'3,4-dihydro-1H-2λ⁶,1-benzothiazine-2,2,4-trione' where MatName = 'F1907-0582'
update Materials set IUPAC_Name = N'2λ⁶-thia-5-azabicyclo[2.2.1]heptane-2,2-dione hydrochloride' where MatName = 'F1907-0858'
update Materials set IUPAC_Name = N'11-hydrazinyl-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7,11-tetraene' where MatName = 'F1908-0034'
update Materials set IUPAC_Name = N'5-hydrazinyl-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),5,8-tetraene' where MatName = 'F1908-0035'
update Materials set IUPAC_Name = N'10-methyl-7-thia-2,4,5-triazatricyclo[6.4.0.0²,⁶]dodeca-1(8),3,5,9,11-pentaen-3-amine' where MatName = 'F1909-0010'
update Materials set IUPAC_Name = N'11-chloro-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7,11-tetraene' where MatName = 'F1910-0034'
update Materials set IUPAC_Name = N'5-chloro-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),5,8-tetraene' where MatName = 'F1910-0035'
update Materials set IUPAC_Name = N'4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7,11-tetraen-11-amine' where MatName = 'F1911-0034'
update Materials set IUPAC_Name = N'10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),5,8-tetraen-5-amine' where MatName = 'F1911-0035'
update Materials set IUPAC_Name = N'3-(5-amino-3-methyl-1H-pyrazol-1-yl)-1λ⁶-thiolane-1,1-dione' where MatName = 'F1958-0022'
update Materials set IUPAC_Name = N'methyl 2-[(1,1-dioxo-1λ⁶-thiolan-3-yl)amino]acetate hydrochloride' where MatName = 'F1974-0018'
update Materials set IUPAC_Name = N'5-hydroxy-2,3,4,5-tetrahydro-1λ⁶-benzothiepine-1,1-dione' where MatName = 'F1974-0023'
update Materials set IUPAC_Name = N'5-hydroxy-7-methyl-2,3,4,5-tetrahydro-1λ⁶-benzothiepine-1,1-dione' where MatName = 'F1974-0024'
update Materials set IUPAC_Name = N'{1,7-dimethyl-2,6-dioxa-10-azatricyclo[5.2.1.0⁴,¹⁰]decan-4-yl}methanol' where MatName = 'F1983-0015'
update Materials set IUPAC_Name = N'3-[(propan-2-yl)amino]-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F2115-0007'
update Materials set IUPAC_Name = N'3-[(butan-2-yl)amino]-1λ⁶-thiolane-1,1-dione hydrochloride' where MatName = 'F2115-0032'
update Materials set IUPAC_Name = N'10-(chloromethyl)-7-thia-9,11-diazatricyclo[6.4.0.0²,⁶]dodeca-1(8),2(6),9-trien-12-one' where MatName = 'F2117-0119'
update Materials set IUPAC_Name = N'3-amino-1λ⁶,2-benzothiazole-1,1-dione' where MatName = 'F2124-0446'
update Materials set IUPAC_Name = N'3-chloro-1λ⁶,2-benzothiazole-1,1-dione' where MatName = 'F2124-0714'
update Materials set IUPAC_Name = N'2-{2-oxo-10-thia-1,8-diazatricyclo[7.3.0.0³,⁷]dodeca-3(7),8-dien-12-yl}acetic acid' where MatName = 'F2135-0503'
update Materials set IUPAC_Name = N'3-acetyl-1,1-dioxo-1λ⁶,3-thiazolidine-4-carboxylic acid' where MatName = 'F2135-0778'
update Materials set IUPAC_Name = N'1,8-diazatricyclo[8.4.0.0³,⁸]tetradecane-2,9-dione' where MatName = 'F2135-1223'
update Materials set IUPAC_Name = N'3-[1-(1,1-dioxo-1λ⁶-thiolan-3-yl)-3,5-dimethyl-1H-pyrazol-4-yl]propanoic acid hydrochloride' where MatName = 'F2145-0392'
update Materials set IUPAC_Name = N'5-amino-6-(2-methoxy-2-oxoethyl)-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),5,8-tetraen-6-ium bromide' where MatName = 'F2145-0535'
update Materials set IUPAC_Name = N'12-(prop-2-yn-1-yl)-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7-trien-11-imine hydrobromide' where MatName = 'F2145-0562'
update Materials set IUPAC_Name = N'12-(prop-2-en-1-yl)-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7-trien-11-imine hydrobromide' where MatName = 'F2145-0566'
update Materials set IUPAC_Name = N'6-(prop-2-en-1-yl)-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),8-trien-5-imine hydrobromide' where MatName = 'F2145-0567'
update Materials set IUPAC_Name = N'12-methyl-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7-trien-11-imine' where MatName = 'F2146-0251'
update Materials set IUPAC_Name = N'9-amino-2-butyl-2-azatricyclo[6.3.1.0⁴,¹²]dodeca-1(11),4,6,8(12),9-pentaen-3-one' where MatName = 'F2146-0309'
update Materials set IUPAC_Name = N'6-[2-(methylsulfanyl)ethyl]-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),8-trien-5-imine hydrochloride' where MatName = 'F2146-0743'
update Materials set IUPAC_Name = N'ethyl 2-{5-imino-10,13-dioxa-4-thia-6-azatricyclo[7.4.0.0³,⁷]trideca-1,3(7),8-trien-6-yl}acetate hydrobromide' where MatName = 'F2146-0762'
update Materials set IUPAC_Name = N'12-propyl-4,6-dioxa-10-thia-12-azatricyclo[7.3.0.0³,⁷]dodeca-1(9),2,7-trien-11-imine hydroiodide' where MatName = 'F2146-0772'
update Materials set IUPAC_Name = N'7-chloro-12-methoxy-5-methyl-3-propyl-2,4,8,13-tetraazatricyclo[7.4.0.0²,⁶]trideca-1(13),3,5,7,9,11-hexaene' where MatName = 'F2147-1046'
update Materials set IUPAC_Name = N'2-(1,1-dioxo-1λ⁶,2,5-thiadiazolidin-2-yl)acetic acid' where MatName = 'F2147-3169'
update Materials set IUPAC_Name = N'7-phenyl-1λ⁶,4-thiazepane-1,1-dione hydrochloride' where MatName = 'F2147-8892'
update Materials set IUPAC_Name = N'7-(2-chlorophenyl)-1λ⁶,4-thiazepane-1,1-dione hydrochloride' where MatName = 'F2147-8893'
update Materials set IUPAC_Name = N'7-(2-fluorophenyl)-1λ⁶,4-thiazepane-1,1-dione hydrochloride' where MatName = 'F2147-8894'
update Materials set IUPAC_Name = N'7-(thiophen-2-yl)-1λ⁶,4-thiazepane-1,1-dione hydrochloride' where MatName = 'F2147-8896'
update Materials set IUPAC_Name = N'tert-butyl 1,1-dioxo-1λ⁶,2,5-thiadiazolidine-2-carboxylate' where MatName = 'F2147-9714'
update Materials set IUPAC_Name = N'2-azadispiro[3.1.3⁶.1⁴]decane' where MatName = 'F2147-9874'
update Materials set IUPAC_Name = N'2λ⁶-thia-8-azaspiro[4.5]decane-2,2-dione hydrochloride' where MatName = 'F2147-9875'
update Materials set IUPAC_Name = N'4-(1,4-diazepan-1-yl)-1λ⁶-thiane-1,1-dione dihydrochloride' where MatName = 'F2148-2609'
update Materials set IUPAC_Name = N'2-(1,1,3-trioxo-2,3-dihydro-1λ⁶,2-benzothiazol-2-yl)propanoic acid' where MatName = 'F2158-0099'
update Materials set IUPAC_Name = N'(2E)-4-(1,1,3-trioxo-2,3-dihydro-1λ⁶,2-benzothiazol-2-yl)but-2-enoic acid' where MatName = 'F2158-0103'
update Materials set IUPAC_Name = N'3-[3,5-dimethyl-4-(piperazin-1-yl)-1H-pyrazol-1-yl]-1λ⁶-thiolane-1,1-dione' where MatName = 'F2158-1491'
update Materials set IUPAC_Name = N'2-methyl-4,4-dioxo-5,6-dihydro-1,4λ⁶-oxathiine-3-carboxylic acid' where MatName = 'F2163-0014'
update Materials set IUPAC_Name = N'3-hydrazinyl-1λ⁶,2-benzothiazole-1,1-dione' where MatName = 'F2165-0005'
update Materials set IUPAC_Name = N'4-methyl-2,3,7,11-tetraazatricyclo[7.4.0.0²,⁶]trideca-1(9),3,5,7-tetraene hydrochloride' where MatName = 'F2167-0716'
update Materials set IUPAC_Name = N'10,10-difluoro-7-azadispiro[2.0.5⁴.1³]decane hydrochloride' where MatName = 'F2167-4772'
update Materials set IUPAC_Name = N'11,11-difluoro-8-azadispiro[3.0.5⁵.1⁴]undecane hydrochloride' where MatName = 'F2167-4773'
update Materials set IUPAC_Name = N'2-(1,1-dioxo-1λ⁶-thiolan-3-yl)-2H,4H,5H,6H-cyclopenta[c]pyrazole-3-carboxylic acid' where MatName = 'F2167-9464'
update Materials set IUPAC_Name = N'2-chloro-1,3,2λ⁵-dioxaphospholan-2-one' where MatName = 'F2167-9508'
update Materials set IUPAC_Name = N'5,11-dihydroxy-1,7-diazatricyclo[7.3.0.0³,⁷]dodecane-2,8-dione' where MatName = 'F2167-9942'
update Materials set IUPAC_Name = N'1,3,5,7-tetraazatricyclo[3.3.1.1³,⁷]decane' where MatName = 'F2173-0429'
update Materials set IUPAC_Name = N'1,3-difluoro-5-(pentafluoro-λ⁶-sulfanyl)benzene' where MatName = 'F2173-1751'
update Materials set IUPAC_Name = N'2-oxo-1-azatricyclo[7.3.1.0⁵,¹³]trideca-3,5,7,9(13)-tetraene-3-carbaldehyde' where MatName = 'F2185-0025'
update Materials set IUPAC_Name = N'10-(aminomethyl)-1-azatricyclo[6.3.1.0⁴,¹²]dodeca-4(12),5,7,9-tetraen-11-one hydrochloride' where MatName = 'F2185-0351'
update Materials set IUPAC_Name = N'3-(aminomethyl)-1-azatricyclo[7.3.1.0⁵,¹³]trideca-3,5,7,9(13)-tetraen-2-one hydrochloride' where MatName = 'F2185-0352'
update Materials set IUPAC_Name = N'6-amino-1-azatricyclo[6.3.1.0⁴,¹²]dodeca-4(12),5,7-trien-2-one' where MatName = 'F2189-0228'
update Materials set IUPAC_Name = N'11-oxo-1-azatricyclo[6.3.1.0⁴,¹²]dodeca-4(12),5,7-triene-6-sulfonyl chloride' where MatName = 'F2189-0232'
update Materials set IUPAC_Name = N'13-amino-9-ethyl-2-oxa-9-azatricyclo[9.4.0.0³,⁸]pentadeca-1(11),3(8),4,6,12,14-hexaen-10-one' where MatName = 'F2189-0287'
update Materials set IUPAC_Name = N'13-amino-6,9-dimethyl-2-oxa-9-azatricyclo[9.4.0.0³,⁸]pentadeca-1(11),3(8),4,6,12,14-hexaen-10-one' where MatName = 'F2189-0289'
update Materials set IUPAC_Name = N'13-amino-6-chloro-2-oxa-9-azatricyclo[9.4.0.0³,⁸]pentadeca-1(11),3(8),4,6,12,14-hexaen-10-one' where MatName = 'F2189-0290'
update Materials set IUPAC_Name = N'3-hydrazinyl-11-methyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F3097-5295'
update Materials set IUPAC_Name = N'1,1-dioxo-1λ⁶-thiolane-3-carboxylic acid' where MatName = 'F3204-0008'
update Materials set IUPAC_Name = N'3-(bromomethyl)-1λ⁶-thiolane-1,1-dione' where MatName = 'F8881-0690'
update Materials set IUPAC_Name = N'2-(1,1-dioxo-1λ⁶,2-thiazolidin-2-yl)acetic acid' where MatName = 'F8881-6556'
update Materials set IUPAC_Name = N'2-(3-hydroxypropyl)-1λ⁶,2-thiazolidine-1,1-dione' where MatName = 'F8885-5413'
update Materials set IUPAC_Name = N'2-(2-aminoethyl)-1λ⁶,2-thiazolidine-1,1-dione hydrochloride' where MatName = 'F8888-7026'
update Materials set IUPAC_Name = N'7-methyl-1λ⁶,4-thiazepane-1,1-dione' where MatName = 'F8888-8114'
update Materials set IUPAC_Name = N'2,2,2-trifluoroethyl N-(1,1-dioxo-1λ⁶-thiolan-3-yl)carbamate' where MatName = 'F8889-3955'
update Materials set IUPAC_Name = N'2-(hydroxymethyl)-1λ⁶-thiane-1,1-dione' where MatName = 'F8889-8324'
update Materials set IUPAC_Name = N'tricyclo[10.4.0.0⁴,⁹]hexadeca-1(12),4(9),5,7,13,15-hexaene' where MatName = 'F9994-0659'
update Materials set IUPAC_Name = N'(1,1-dioxo-1λ⁶-thian-4-yl)methyl methanesulfonate' where MatName = 'F9994-5185'
update Materials set IUPAC_Name = N'(1R,9S)-7,11-diazatricyclo[7.3.1.0²,⁷]trideca-2,4-dien-6-one' where MatName = 'F9994-5373'
update Materials set IUPAC_Name = N'1-azatricyclo[7.3.1.0⁵,¹³]trideca-5,7,9(13)-trien-6-ol' where MatName = 'F9995-0032'
update Materials set IUPAC_Name = N'3-chloro-5,11-dimethyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F9995-0059'
update Materials set IUPAC_Name = N'methyl[methyl(oxo)phenyl-λ⁶-sulfanylidene]amine' where MatName = 'F9995-0088'
update Materials set IUPAC_Name = N'3-chloro-8-thia-4,6-diazatricyclo[7.5.0.0²,⁷]tetradeca-1(9),2(7),3,5-tetraene' where MatName = 'F9995-0109'
update Materials set IUPAC_Name = N'8-methoxy-4-methyl-5,12-dithia-3-azatricyclo[7.3.0.0²,⁶]dodeca-1,3,6,8,10-pentaene' where MatName = 'F9995-0302'
update Materials set IUPAC_Name = N'3-chloro-5-ethyl-8-thia-4,6-diazatricyclo[7.4.0.0²,⁷]trideca-1(9),2(7),3,5-tetraene' where MatName = 'F9995-0390'
update Materials set IUPAC_Name = N'ethyl 4-oxo-3-oxa-13-azatetracyclo[7.7.1.0²,⁷.0¹³,¹⁷]heptadeca-1,5,7,9(17)-tetraene-5-carboxylate' where MatName = 'F9995-0517'
update Materials set IUPAC_Name = N'methyl 12-methyl-2-oxo-6-thia-1,8-diazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylate' where MatName = 'F9995-1081'
update Materials set IUPAC_Name = N'methyl 2-oxo-6-thia-1,8-diazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylate' where MatName = 'F9995-1082'
update Materials set IUPAC_Name = N'methyl 10-methyl-2-oxo-6-thia-1,8-diazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylate' where MatName = 'F9995-1083'
update Materials set IUPAC_Name = N'2-oxo-6-propyl-1,6,8-triazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylic acid' where MatName = 'F9995-1093'
update Materials set IUPAC_Name = N'6-(2-methoxyethyl)-2-oxo-1,6,8-triazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylic acid' where MatName = 'F9995-1094'
update Materials set IUPAC_Name = N'6-butyl-2-oxo-1,6,8-triazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylic acid' where MatName = 'F9995-1096'
update Materials set IUPAC_Name = N'6-(3-methoxypropyl)-2-oxo-1,6,8-triazatricyclo[7.4.0.0³,⁷]trideca-3(7),4,8,10,12-pentaene-5-carboxylic acid' where MatName = 'F9995-1097'
update Materials set IUPAC_Name = N'12-bromo-3-methyl-9-(pyridin-2-yl)-2,4,5,8-tetraazatricyclo[8.4.0.0²,⁶]tetradeca-1(14),3,5,8,10,12-hexaene' where MatName = 'F9995-1802'

*/