CREATE DATABASE IF NOT EXISTS terms;
CREATE SCHEMA IF NOT EXISTS terms;
CREATE USER 'userA'@'localhost' IDENTIFIED BY 'pwd';
GRANT ALL PRIVILEGES ON terms.* TO 'userA'@'localhost';

USE terms;

DROP TABLE IF EXISTS TermLog;
DROP TABLE IF EXISTS Term;
DROP TABLE IF EXISTS Category;

CREATE TABLE Category
(
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE Term
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT        NOT NULL,
    name        VARCHAR(255)  NOT NULL UNIQUE,
    description VARCHAR(1000) NOT NULL,
    link        VARCHAR(1000) NOT NULL,
    CONSTRAINT fk_category_term FOREIGN KEY (category_id) REFERENCES Category (id)
);

CREATE TABLE TermLog
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    logTimeStamp  DATETIME      NOT NULL,
    term_id       BIGINT        NOT NULL,
    previousValue VARCHAR(1000) NOT NULL,
    newValue      VARCHAR(1000) NOT NULL,
    CONSTRAINT fk_log_term FOREIGN KEY (term_id) REFERENCES Term (id)
);

INSERT INTO Category (name)
VALUES ('Default'),
       ('Protokolle'),
       ('Netzwerk'),
       ('Sicherheit'),
       ('Datenbank'),
       ('Programmierung');

INSERT INTO Term (category_id, name, description, link)
VALUES (1, 'Default', '', '');

DROP TRIGGER IF EXISTS insert_term_log;
DROP TRIGGER IF EXISTS update_term_log;
DROP TRIGGER IF EXISTS delete_term_log;

DELIMITER $$
CREATE TRIGGER `insert_term_log`
    AFTER INSERT
    ON `Term`
    FOR EACH ROW
BEGIN
    INSERT INTO TermLog (logTimeStamp, term_id, previousValue, newValue)
    VALUES (NOW(), NEW.id, 'null', CONCAT(NEW.name, ', ', NEW.description, ', ', NEW.link));
END$$
CREATE TRIGGER `update_term_log`
    AFTER UPDATE
    ON `Term`
    FOR EACH ROW
BEGIN
    IF (OLD.id = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant update Term 1';
    END IF;
    INSERT INTO TermLog (logTimeStamp, term_id, previousValue, newValue)
    VALUES (NOW(), OLD.id,
            CONCAT(OLD.name, ', ', OLD.description, ', ', OLD.link),
            CONCAT(NEW.name, ', ', NEW.description, ', ', NEW.link));
END$$
CREATE TRIGGER `delete_term_log`
    BEFORE DELETE
    ON `Term`
    FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cant delete Terms';
END$$
DELIMITER ;

INSERT INTO Term (name, category_id, description, link)
VALUES ('Routing', 3,
        'Das Routing ist ein Vorgang, der den Weg zur nächsten Station eines Datenpakets bestimmt. Im Vordergrund steht die Wahl der Route aus den verfügbaren Routen, die in einer Routing-Tabelle gespeichert sind. Diese Parameter und Kriterien können für die Wahl einer Route von Bedeutung sein: Verbindungskosten, notwendige Bandbreite, Ziel-Adresse, Subnetz, Verbindungsart, Verbindungsinformationen und bekannte Netzwerkadressen.',
        'https://www.elektronik-kompendium.de/sites/net/0903151.htm'),
       ('Sequenzielles Abarbeiten', 6,
        'Die sequentielle oder serielle Programmierung führt Befehle nacheinander aus. Dabei leitet sie die Reihenfolge der nötigen Rechenoperationen aus einer Kausalkette von inhaltlichen und zeitlichen Abhängigkeiten ab. Ziel ist eine Chronologie von Ereignissen, in der jede Aktion, die das Ergebnis einer vorangegangenen Aktion voraussetzt, erst dann ausgeführt wird, wenn dieses Ergebnis vorliegt.',
        'https://www.micromata.de/blog/parallele-programmierung/'),
       ('Referentielle Integrität', 5,
        'Unter referentielle Integrität versteht man Bedingungen, die zur Sicherung der Datenintegrität bei Nutzung relationaler Datenbanken beitragen können. Nach der RI-Regel dürfen Datensätze (über ihre Fremdschlüssel) nur auf existierende Datensätze verweisen.',
        'https://de.wikipedia.org/wiki/Referentielle_Integrit%C3%A4t'),
       ('DNS', 3,
        'Das Domain Name System ist einer der wichtigsten Dienste in vielen IP-basierten Netzwerken. Seine Hauptaufgabe ist die Beantwortung von Anfragen zur Namensauflösung. Dabei wird zumeist ein für Menschen lesbarer und merkbarer Name als Adresse zu einer IP-Adresse übersetzt.',
        'https://de.wikipedia.org/wiki/Domain_Name_System'),
       ('DHCP', 3,
        'Als Kommunikationsprotokoll ermöglicht das Dynamic Host Configuration Protocol die Zuweisung der Netzwerkkonfiguration an Clients durch einen Server. DHCP benutzt die UDP-Ports 67 und 68. DHCP ermöglicht es, angeschlossene Clients ohne manuelle Konfiguration der Netzschnittstelle in ein bestehendes Netz einzubinden. Nötige Informationen wie IP-Adresse, Netzmaske, Gateway, Name Server (DNS) und ggf. weitere Einstellungen werden automatisch vergeben, sofern das Betriebssystem des jeweiligen Clients dies unterstützt.',
        'https://de.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol'),
       ('Verzeichnisdienst', 5,
        'Ein Verzeichnisdienst (in Englisch directory service) stellt in einem Netzwerk eine zentrale Sammlung von Daten bestimmter Art zur Verfügung. Die in einer hierarchischen Datenbank gespeicherten Daten können nach dem Client-Server-Prinzip verglichen, gesucht, erstellt, modifiziert und gelöscht werden. Zu beachten ist hierbei, dass „Verzeichnis“ im Sinne beispielsweise eines Telefonbuches gemeint ist und nicht im Sinne von „Dateiordner“ in Computersystemen.',
        'https://de.wikipedia.org/wiki/Verzeichnisdienst'),
       ('IPv4-Adresse', 2,
        'IPv4 (Internet Protocol Version 4), vor der Entwicklung von IPv6 auch einfach IP, ist die vierte Version des Internet Protocols (IP). Es war die erste Version des Internet Protocols, welche weltweit verbreitet und eingesetzt wurde, und bildet eine wichtige technische Grundlage des Internets. Die IP-Adresse kann in dezimal, binär, oktal und hexadezimal sowohl in der Punkt-, als auch in der Nichtpunktnotation dargestellt werden. IPv4 benutzt 32-Bit-Adressen, daher können in einem Netz maximal 4.294.967.296 Adressen vergeben werden.',
        'https://de.wikipedia.org/wiki/IPv4'),
       ('Subnetzmaske', 3,
        'Die Netzmaske, Netzwerkmaske oder Subnetzmaske ist eine Bitmaske, die im Netzwerkprotokoll IPv4 bei der Beschreibung von IP-Netzen angibt, welche Bit-Position innerhalb der IP-Adresse für die Adressierung des Netz- bzw. Host-Anteils genutzt werden soll. Der Netzanteil erstreckt sich innerhalb der IP-Adresse lückenlos von links nach rechts; der Hostanteil von rechts nach links. Der für die Adressierung des Netzanteils innerhalb der IP-Adresse genutzte Bereich wird auch Präfix genannt.',
        'https://de.wikipedia.org/wiki/Netzmaske'),
       ('IPv6-Adresse', 2,
        'Das Internet Protocol Version 6 (IPv6), früher auch Internet Protocol next Generation (IPng) genannt, ist ein von der Internet Engineering Task Force (IETF) seit 1998 standardisiertes Verfahren zur Übertragung von Daten in paketvermittelnden Rechnernetzen, insbesondere dem Internet und die Weiterentwicklung von IPv4. IPv6-Adressen sind 128 Bit lang (IPv4: 32 Bit). Die ersten 64 Bit bilden das sogenannte Präfix, die letzten 64 Bit bilden bis auf Sonderfälle einen für die Netzwerkschnittstelle eindeutigen Interface-Identifier.',
        'https://de.wikipedia.org/wiki/IPv6'),
       ('NoSQL', 5,
        'NoSQL (Not only SQL) bezeichnet Datenbanken, die einen nicht-relationalen Ansatz verfolgen und damit mit der langen Geschichte relationaler Datenbanken brechen. Diese Datenspeicher benötigen keine festgelegten Tabellenschemata und versuchen Joins zu vermeiden. Sie skalieren dabei horizontal. Im akademischen Umfeld werden sie häufig als „strukturierte Datenspeicher“ bezeichnet.',
        'https://de.wikipedia.org/wiki/NoSQL'),
       ('Symmetrische Verschlüsselung', 4,
        'Mit der symmetrischen Verschlüsselung, auch Secret-Key Verschlüsselung genannt, kann man verschlüsselt Informationen austauschen. Dabei wird ein Schlüssel sowohl zur Verschlüsselung, als auch zur Entschlüsselung verwendet. Sollte der Schlüssel daher bekannt werden sind sämtliche Informationen sofort ungesichert.',
        'https://studyflix.de/informatik/symmetrische-verschlusselung-1610'),
       ('Private-Public-Key', 4,
        'Die asymmetrische Verschlüsselung ist ein kryptographisches Verfahren, bei dem im Gegensatz zu einem symmetrischen Kryptosystem die kommunizierenden Parteien keinen gemeinsamen geheimen Schlüssel zu kennen brauchen. Jeder Benutzer erzeugt sein eigenes Schlüsselpaar, das aus einem geheimen Teil (privater Schlüssel) und einem nicht geheimen Teil (öffentlicher Schlüssel) besteht. Mit dem öffentlichen Schlüssel können Informationen so verschlüsselt werden dass man diese nur mit dem privaten Schlüssel wieder entschlüsseln kann.',
        'https://de.wikipedia.org/wiki/Asymmetrisches_Kryptosystem'),
       ('Einfüge-Anomalie', 5,
        'In der Informatik bezeichnen Anomalien in relationalen Datenbanken Fehlverhalten der Datenbank. Durch nicht normalisierte Datenstrukturen oder unkontrollierten Mehrfachzugriff auf Daten können Inkonsistenzen entstehen, diese sind hier mit Anomalie gemeint. Beim Einfügen von Daten in eine Datenbank spricht man von einer Einfüge-Anomalie, wenn ein neues Tupel in die Relation nicht oder nur schwierig eingetragen werden kann, weil nicht zu allen Attributen des Primärschlüssels Werte vorliegen.',
        'https://de.wikipedia.org/wiki/Anomalie_(Informatik)'),
       ('DBMS', 5,
        'Eine Datenbank besteht aus zwei Teilen: der Verwaltungssoftware, genannt Datenbankmanagementsystem (DBMS), und der Menge der zu verwaltenden Daten, der Datenbank (DB) im engeren Sinn, zum Teil auch „Datenbasis“ genannt. Die Verwaltungssoftware organisiert intern die strukturierte Speicherung der Daten und kontrolliert alle lesenden und schreibenden Zugriffe auf die Datenbank. Zur Abfrage und Verwaltung der Daten bietet ein Datenbanksystem eine Datenbanksprache an.',
        'https://de.wikipedia.org/wiki/Datenbank'),
       ('Objektorientierung', 6,
        'Unter Objektorientierung (kurz OO) versteht man in der Entwicklung von Software eine Sichtweise auf komplexe Systeme, bei der ein System durch das Zusammenspiel kooperierender Objekte beschrieben wird. Der Begriff Objekt ist dabei unscharf gefasst; wichtig an einem Objekt ist nur, dass ihm bestimmte Attribute (Eigenschaften) und Methoden zugeordnet sind und dass es in der Lage ist, von anderen Objekten Nachrichten zu empfangen beziehungsweise an diese zu senden. Dabei sind folgende Punkte wesentliche Ziele der Objektorientierung: Vererbung, Polymorphie und Kapselung.',
        'https://de.wikipedia.org/wiki/Objektorientierung'),
       ('Proxy', 3,
        'Ein Proxy („Stellvertreter“) ist eine Kommunikationsschnittstelle in einem Netzwerk. Er arbeitet als Vermittler, der auf der einen Seite Anfragen entgegennimmt, um dann über seine eigene Adresse eine Verbindung zur anderen Seite herzustellen.',
        'https://de.wikipedia.org/wiki/Proxy_(Rechnernetz)'),
       ('(S)FTP', 2,
        'Das File Transfer Protocol (Dateiübertragungsprotokoll) ist ein zustandsbehaftetes Netzwerkprotokoll zur Übertragung von Dateien über IP-Netzwerke. Das SSH File Transfer Protocol oder Secure File Transfer Protocol (SFTP) ist eine für die Secure Shell (SSH) entworfene Alternative zum File Transfer Protocol, die Verschlüsselung ermöglicht. Im Unterschied zum FTP über TLS (FTPS) begnügt sich SFTP mit einer einzigen Verbindung zwischen Client und Server.',
        'https://de.wikipedia.org/wiki/SSH_File_Transfer_Protocol');