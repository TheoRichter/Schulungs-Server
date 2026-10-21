#!/bin/bash

# Pfad zur SQLite-Datenbanken
BERUFSCHULE="/netzlaufwerk/OfficelleTestDBS/Berufschule/Berufschule.sqlite"
ENM_SVWS="/netzlaufwerk/SVWS-TestMDBs/ENM-Json/ENM-Testdaten-01/ENM_SVWS.sqlite"
GESAMTSCHULE="/netzlaufwerk/OfficelleTestDBS/Gesamtschule/Gesamtschule.sqlite"
GRUNDSCHULE="/netzlaufwerk/OfficelleTestDBS/Grundschule/Grundschule.sqlite"
GRUNDSCHULE_1Hj="/netzlaufwerk/OfficelleTestDBS/Grundschule/Grundschule_1Hj.sqlite"
GRUNDSCHULE_2Hj="/netzlaufwerk/OfficelleTestDBS/Grundschule/Grundschule_2Hj.sqlite"
GRUNDSCHULE_1HjLeistungsdaten="/netzlaufwerk/OfficelleTestDBS/Grundschule/Grundschule_1HjLeistungsdaten.sqlite"
GRUNDSCHULE_2HjLeistungsdaten="/netzlaufwerk/OfficelleTestDBS/Grundschule/Grundschule_2HjLeistungsdaten.sqlite"
GYMNASIUM_GOSt_DB-1_VorbereitungEFPlanung="/netzlaufwerk/OfficelleTestDBS/Gymnasium/GOSt_DB-1_VorbereitungEFPlanung.sqlite"
GYMNASIUM_GOSt_DB-2_Laufbahnen10EF-zumBlocken="/netzlaufwerk/OfficelleTestDBS/Gymnasium/GOSt_DB-2_Laufbahnen10EF-zumBlocken.sqlite"
GYMNASIUM_GOSt_DB-3_Blockungen10EFmitFehlern="/netzlaufwerk/OfficelleTestDBS/Gymnasium/GOSt_DB-3_Blockungen10EFmitFehlern.sqlite"
GYMNASIUM_GOSt_DB-4-KlausurplanungEF2="/netzlaufwerk/OfficelleTestDBS/Gymnasium/GOSt_DB-4-KlausurplanungEF2.sqlite"
S1Schulung="/netzlaufwerk/OfficelleTestDBS/S1Schulung/S1Schulung.sqlite"
S2Schulung="/netzlaufwerk/OfficelleTestDBS/S2Schulung/S2Schulung.sqlite"
# SQLite-Abfragen definieren
#############################################################################################################################################
SQL_BEFEHLE_ENM_SVWS=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_GESAMTSCHULE=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
############################################################################################################################################
SQL_BEFEHLE_GRUNDSCHULE=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_GYMNASIUM_GOSt_DB-1_VorbereitungEFPlanung=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_GYMNASIUM_GOSt_DB-2_Laufbahnen10EF-zumBlocken=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_GYMNASIUM_GOSt_DB-3_Blockungen10EFmitFehlern=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_GYMNASIUM_GOSt_DB-4-KlausurplanungEF2=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_S1Schulung=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
SQL_BEFEHLE_S2Schulung=$(cat <<EOF
UPDATE K_Lehrer SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET AnmeldeDatum = DATE(AnmeldeDatum, '+1 year');
UPDATE Schueler SET Aufnahmedatum = DATE(Aufnahmedatum, '+1 year');
UPDATE Schueler SET LSSchulEntlassDatum = DATE(LSSchulEntlassDatum, '+1 year');
UPDATE Schueler SET Geburtsdatum = DATE(Geburtsdatum, '+1 year');
UPDATE Schueler SET Religionsabmeldung = date(Religionsabmeldung, '+1 year') WHERE Religionsabmeldung IS NOT NULL AND Religionsabmeldung != '';
UPDATE Schueler SET JahrWechsel_SI = JahrWechsel_SI + 1 WHERE JahrWechsel_SI IS NOT NULL;
UPDATE Schueler SET JahrWechsel_SII = JahrWechsel_SII + 1 WHERE JahrWechsel_SII IS NOT NULL;
UPDATE Schueler SET JahrZuzug = JahrZuzug + 1 WHERE JahrZuzug IS NOT NULL;
UPDATE Schueler SET Einschulungsjahr = Einschulungsjahr + 1;
UPDATE Schuljahresabschnitte SET Jahr = Jahr + 1;
EOF
)
#############################################################################################################################################
# SQL ausführen
#############################################################################################################################################
sqlite3 "BERUFSCHULE" "$SQL_BEFEHLE_BERUFSCHULE"
#############################################################################################################################################
sqlite3 "$ENM_SVWS" "$SQL_BEFEHLE_ENM_SVWS"
#############################################################################################################################################
sqlite3 "$GESAMTSCHULE" "$SQL_BEFEHLE_GESAMTSCHULE"
#############################################################################################################################################
sqlite3 "$GRUNDSCHULE" "$SQL_BEFEHLE_GRUNDSCHULE"
#############################################################################################################################################
sqlite3 "$GYMNASIUM_GOSt_DB-1_VorbereitungEFPlanung" "$SQL_BEFEHLE_GYMNASIUM_GOSt_DB-1_VorbereitungEFPlanung"
#############################################################################################################################################
sqlite3 "$GYMNASIUM_GOSt_DB-2_Laufbahnen10EF-zumBlocken" "$SQL_BEFEHLE_GYMNASIUM_GOSt_DB-2_Laufbahnen10EF-zumBlocken"
#############################################################################################################################################
sqlite3 "$GYMNASIUM_GOSt_DB-3_Blockungen10EFmitFehlern" "$SQL_BEFEHLE_GYMNASIUM_GOSt_DB-3_Blockungen10EFmitFehlern"
#############################################################################################################################################
sqlite3 "$GYMNASIUM_GOSt_DB-4-KlausurplanungEF2" "$SQL_BEFEHLE_GYMNASIUM_GOSt_DB-4-KlausurplanungEF2"
#############################################################################################################################################
sqlite3 "$S1Schulung" "$SQL_BEFEHLE_S1Schulung"
#############################################################################################################################################
sqlite3 "$S2Schulung" "$SQL_BEFEHLE_S2Schulung"
#
echo "---------------------------------------------------------------------------------------------------"
echo "Datenbanken wurde aktualisiert."
echo "---------------------------------------------------------------------------------------------------"
cd /var/www/html/sh
echo "---------------------------------------------------------------------------------------------------"
bash Berufschule.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das BerufschulSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash ENM_SVWS.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das ENM_SVWSSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash Gesamtschule.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GesamtschulSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash GOSt_DB-1_VorbereitungEFPlanung.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GOSt_DB-1Schemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash GOSt_DB-2_Laufbahnen10EF-zumBlocken.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GOSt_DB-2Schemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash GOSt_DB-3_Blockungen10EFmitFehlern.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GOSt_DB-3Schemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash GOSt_DB-4-KlausurplanungEF2.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GOSt_DB-4Schemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash Grundschule.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das GrundschulSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash S1Schulung.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das S1SchulungsSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
bash S2Schulung.sh
echo "---------------------------------------------------------------------------------------------------"
echo "Das S2SchulungsSchemata wurden mit dem neuen Jahrgang eingespiele und die Container neu gestartet"
echo "---------------------------------------------------------------------------------------------------"
