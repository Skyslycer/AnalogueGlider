import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class AnalogueGliderApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new AnalogueGliderView() ];
    }

}

function getApp() as AnalogueGliderApp {
    return Application.getApp() as AnalogueGliderApp;
}