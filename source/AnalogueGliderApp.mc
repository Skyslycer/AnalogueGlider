import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AnalogueGliderApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {}

    function onStop(state as Dictionary?) as Void {}

    function getInitialView() {
        return [new AnalogueGliderView()];
    }

    function onSettingsChanged() as Void {
        settingsChanged = true;
    }
}

function getApp() as AnalogueGliderApp {
    return Application.getApp() as AnalogueGliderApp;
}
