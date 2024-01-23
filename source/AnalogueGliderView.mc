import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time;
using Toybox.Time.Gregorian;

const gliderIds = {
    208 => Rez.Drawables.Glider208,
    218 => Rez.Drawables.Glider218,
    240 => Rez.Drawables.Glider240,
    260 => Rez.Drawables.Glider260,
    280 => Rez.Drawables.Glider280,
    360 => Rez.Drawables.Glider360,
    390 => Rez.Drawables.Glider390,
    416 => Rez.Drawables.Glider416,
    454 => Rez.Drawables.Glider454,
};

var width;
var height;
var screenCenterPoint;
var img;
var topField;
var bottomField;
var settingsChanged;

class AnalogueGliderView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        width = dc.getWidth();
        height = dc.getHeight();
        screenCenterPoint = [width / 2, height / 2];
    }

    function onShow() as Void {
        img = Toybox.WatchUi.loadResource(gliderIds[height]);
        loadSettings();
    }

    function onUpdate(dc as Dc) as Void {
        if (settingsChanged) {
            loadSettings();
        }
        View.onUpdate(dc);
        dc.drawBitmap(width / 2 - img.getWidth() / 2, height / 2 - img.getHeight() / 2, img);
        drawHours(dc);
        drawHands(dc);
        drawCenterCircle(dc);
        drawField(topField, dc, width / 2, height / 7);
        var yMultiplier = 11;
        if (height < 300) {
            yMultiplier = 10.2;
        }
        drawField(bottomField, dc, width / 2, (height / 14) * yMultiplier);
    }

    function onHide() as Void {}

    function onExitSleep() as Void {}

    function onEnterSleep() as Void {}

    function loadSettings() {
        topField = Application.Properties.getValue("TopField") as Number;
        bottomField = Application.Properties.getValue("BottomField") as Number;
        settingsChanged = false;
    }

    function drawField(fieldNum, dc, x, y) {
        var str = "";
        switch (fieldNum) {
            case 0:
                var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
                str = Lang.format("$1$ $2$", [info.day, info.month]);
                break;
            case 1:
                str = ActivityMonitor.getInfo().steps.format("%d");
                break;
            case 2:
                var heartRate = Activity.getActivityInfo().currentHeartRate;
                if (heartRate != null) {
                    str = heartRate.format("%d");
                } else {
                    str = "--";
                }
                break;
            case 3:
                str = (System.getSystemStats().battery + 0.5).format("%d") + "%";
                break;
            case 4:
                var utcTime = Gregorian.utcInfo(Time.now(), Time.FORMAT_LONG);
                str = Lang.format("$1$:$2$", [utcTime.hour, utcTime.min]);
                if (utcTime.min < 10) {
                    str = Lang.format("$1$:0$2$", [utcTime.hour, utcTime.min]);
                }
                break;
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_TINY, str, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHours(dc) {
        var outerRad = width / 2;
        var innerRad = outerRad - 20;
        var num = 0;
        for (var i = 0; i < 12; i++) {
            var angle = (Math.PI / 6) * i;
            var sX = outerRad + innerRad * Math.sin(angle);
            var sY = outerRad - innerRad * Math.cos(angle);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            var offset = 25;
            if (height < 300) {
                offset = 15;
            }
            var numStr = num.toString();
            if (num == 0) {
                numStr = "12";
            }
            dc.drawText(sX, sY - offset, Graphics.FONT_SMALL, numStr, Graphics.TEXT_JUSTIFY_CENTER);
            num++;
        }
    }

    function drawCenterCircle(dc) {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 7);
    }

    function drawHands(dc) {
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        var clockTime = System.getClockTime();
        var hourHandAngle = (clockTime.hour % 12) * 60 + clockTime.min;
        hourHandAngle = hourHandAngle / (12 * 60.0);
        hourHandAngle = hourHandAngle * Math.PI * 2;
        dc.fillPolygon(generateHandCoordinates(screenCenterPoint, hourHandAngle, height / 5, 0, width / 50));

        var minuteHandAngle = (clockTime.min / 60.0) * Math.PI * 2;
        dc.fillPolygon(generateHandCoordinates(screenCenterPoint, minuteHandAngle, height / 3, 0, width / 120));
    }

    private function generateHandCoordinates(
        centerPoint,
        angle,
        handLength,
        tailLength,
        width
    ) as Array<Array<Float> > {
        var coords = [
            [-(width / 2), tailLength],
            [-(width / 2), -handLength],
            [width / 2, -handLength],
            [width / 2, tailLength],
        ];
        var result = new Array<Array<Float> >[4];
        var cos = Math.cos(angle);
        var sin = Math.sin(angle);

        for (var i = 0; i < 4; i++) {
            var x = coords[i][0] * cos - coords[i][1] * sin + 0.5;
            var y = coords[i][0] * sin + coords[i][1] * cos + 0.5;
            result[i] = [centerPoint[0] + x, centerPoint[1] + y];
        }

        return result;
    }
}
