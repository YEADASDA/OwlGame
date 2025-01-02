-- Diese Funktion wird einmalig beim Start des Spiels ausgeführt
function love.load()
    -- Laden der Grafiken für die Haeckse, den Stern und die Eule
    haeckseImage = love.graphics.newImage("haeckse.png")
    starImage = love.graphics.newImage("star.png")

    -- Anfangsrichtung der Eule wird auf "nach unten" gesetzt
    owlDirection = "down"
    -- Der Stern ist zu Beginn unsichtbar
    starVisibility = false
    -- Die Eule ist zu Beginn sichtbar
    owlVisibility = true

    -- Laden der Eulengrafik
    owlImage = love.graphics.newImage("owl1.png")
    -- Startposition der Eule (x, y)
    owlX = 1300
    owlY = 300
    -- Startposition der Haeckse (x, y)
    haeckseX = 50
    haeckseY = 300
    -- Anfangsposition des Sterns (x, y)
    starX = 250
    starY = 0
end

-- Diese Funktion wird kontinuierlich ausgeführt und aktualisiert den Zustand des Spiels
function love.update(dt)
    -- Bewegung der Eule nach unten, wenn die Richtung "down" ist
    if owlDirection == "down" then
        owlY = owlY + 150 * dt -- dt sorgt für framerate-unabhängige Bewegung
    end

    -- Bewegung der Eule nach oben, wenn die Richtung "up" ist
    if owlDirection == "up" then
        owlY = owlY - 150 * dt
    end

    -- Richtungswechsel der Eule, wenn sie den unteren Rand erreicht
    if owlY >= 500 then
        owlDirection = "up"
    end

    -- Richtungswechsel der Eule, wenn sie den oberen Rand erreicht
    if owlY <= -75 then
        owlDirection = "down"
    end

    -- Bewegung des Sterns nach rechts, solange er sichtbar ist und sich innerhalb des Spielfelds befindet
    if starVisibility == true and starX <= 1300 then
        starX = starX + 150 * dt
    end

    -- Stern verschwindet und wird zurückgesetzt, wenn er den rechten Rand erreicht
    if starVisibility == true and starX >= 1300 then
        starVisibility = false
        starX = 250
    end

    -- Die Eule bewegt sich kontinuierlich nach links
    owlX = owlX - 30 * dt

    -- Bewegung der Haeckse nach unten, wenn "s" gedrückt wird und sie sich innerhalb des Spielfelds befindet
    if love.keyboard.isDown("s") and haeckseY < 450 then
        haeckseY = haeckseY + 150 * dt
    end

    -- Bewegung der Haeckse nach oben, wenn "w" gedrückt wird und sie sich innerhalb des Spielfelds befindet
    if love.keyboard.isDown("w") and haeckseY > 0 then
        haeckseY = haeckseY - 150 * dt
    end

    -- Schießen eines Sterns: Wenn die Leertaste gedrückt wird und der Stern nicht sichtbar ist
    if love.keyboard.isDown("space") and starVisibility == false then
        starVisibility = true -- Stern wird sichtbar
        starY = haeckseY + 20 -- Stern wird aus der aktuellen Position der Haeckse abgeschossen
    end

    -- Prüfen auf eine Kollision zwischen dem Stern und der Eule
    if starVisibility and checkCollision(starX, starY, 40, 40, owlX, owlY, 120, 120) then
        owlVisibility = false -- Die Eule wird unsichtbar gemacht, wenn eine Kollision erkannt wird
    end
end

-- Diese Funktion zeichnet die Grafiken und den Hintergrund auf dem Bildschirm
function love.draw()
    -- Hintergrundfarbe setzen
    love.graphics.clear(0.15, 0.24, 0.35) -- RGB-Werte für eine dunkle blaue Farbe
    -- Zeichnen der Haeckse an ihrer aktuellen Position
    love.graphics.draw(haeckseImage, haeckseX, haeckseY)

    -- Zeichnen der Eule, falls sie sichtbar ist
    if owlVisibility == true then
        love.graphics.draw(owlImage, owlX, owlY)
    end

    -- Zeichnen des Sterns, falls er sichtbar ist
    if starVisibility == true then
        love.graphics.draw(starImage, starX, starY)
    end
end

-- Funktion zur Prüfung, ob zwei Rechtecke kollidieren
-- Parameter: x1, y1 (Position des ersten Rechtecks), w1, h1 (Breite und Höhe des ersten Rechtecks)
--            x2, y2 (Position des zweiten Rechtecks), w2, h2 (Breite und Höhe des zweiten Rechtecks)
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    -- Rückgabe von true, wenn sich die Rechtecke überlappen
    return x1 < x2 + w2 and -- Rechte Kante von Rechteck 1 ist links der rechten Kante von Rechteck 2
           x2 < x1 + w1 and -- Linke Kante von Rechteck 2 ist links der rechten Kante von Rechteck 1
           y1 < y2 + h2 and -- Untere Kante von Rechteck 1 ist über der unteren Kante von Rechteck 2
           y2 < y1 + h1    -- Obere Kante von Rechteck 2 ist über der unteren Kante von Rechteck 1
end
