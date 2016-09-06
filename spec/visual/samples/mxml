<?xml version="1.0"?>
<!-- mxmlAdvanced/myComponents/DestinationComp.mxml -->
<s:VGroup xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:s="library://ns.adobe.com/flex/spark"
    xmlns:mx="library://ns.adobe.com/flex/mx">

    <fx:Script>
        <![CDATA[
            // Define variable to reference calling file.
            [Bindable]
            public var caller:CallingComponent;
        ]]>
    </fx:Script>

    <s:TextInput id="mytext"
        text="{caller.text1.text}"/>
</s:VGroup>

<?xml version="1.0"?>
<!-- mxmlAdvanced/myComponents/StateComboBoxSetGetBinding.mxml -->
<s:ComboBox xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:s="library://ns.adobe.com/flex/spark"
    xmlns:mx="library://ns.adobe.com/flex/mx">

    <fx:Script>
        <![CDATA[
            import mx.collections.ArrayList;
            import flash.events.Event;

            // Define private variables.
            private var stateArrayShort:ArrayList = new ArrayList(["AK", "AL"]);
            private var stateArrayLong:ArrayList = new ArrayList(["Arkansas", "Alaska"]);

            private var __shortNames:Boolean = true;

            public function set shortNames(val:Boolean):void {
                __shortNames = val;
                if (__shortNames) {
                    dataProvider=stateArrayShort; }
                else {
                    dataProvider=stateArrayLong; }
                    // Create and dispatch event.
                    dispatchEvent(new Event("changeShortNames"));
            }

            // Include the [Bindable] metadata tag.
            [Bindable(event="changeShortNames")]
            public function get shortNames():Boolean {
                return __shortNames;
            }
        ]]>
    </fx:Script>
</s:ComboBox>

<?xml version="1.0"?>
<!-- mxmlAdvanced/myComponents/StateComboBoxPassRefToTA.mxml -->
<s:ComboBox xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:s="library://ns.adobe.com/flex/spark"
    xmlns:mx="library://ns.adobe.com/flex/mx"
    close="handleCloseEvent(event);">

    <fx:Script>
        <![CDATA[
            import flash.events.Event;
            import spark.components.TextArea;

            // Define a variable of type mx.controls.TextArea.
            public var outputTA:TextArea;

            public function handleCloseEvent(eventObj:Event):void {
                outputTA.text=String(this.selectedIndex);
            }
        ]]>
    </fx:Script>

    <s:dataProvider>
        <s:ArrayList>
            <fx:String>AK</fx:String>
            <fx:String>AL</fx:String>
        </s:ArrayList>
    </s:dataProvider>
</s:ComboBox>

<?xml version="1.0"?>
<!-- createcomps_mxml/myComponents/StateComboBoxWithStyleClassSel.mxml -->
<s:ComboBox xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:s="library://ns.adobe.com/flex/spark"
    xmlns:mx="library://ns.adobe.com/flex/mx"
    styleName="myCBStyle">

    <fx:Style>
        .myCBStyle {
            fontWeight : bold;
            fontSize : 15;
            }
    </fx:Style>

    <s:dataProvider>
        <s:ArrayList>
            <fx:String>AK</fx:String>
            <fx:String>AL</fx:String>
        </s:ArrayList>
    </s:dataProvider>
</s:ComboBox>
