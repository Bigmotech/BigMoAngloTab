
// --------------------------------------------
// MuseScore plugin: Big Mo Anglo Tab
// For MuseScore 4 before 4.4
// --------------------------------------------

import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MuseScore 3.0
import Muse.Ui 1.0
import Muse.UiComponents 1.0

MuseScore {
	menuPath: "Plugins.Anglo Tab";
	title: "BigMo Anglo Tab";
	version: "0.1";
	description: "Add fingering for Anglo Concertina to the score using a dialog box.";
	thumbnailName: "anglo-fingering.png";
	categoryCode: "composing-arranging-tools";
	requiresScore: true;
	pluginType: "dialog";
	width:  350;
	height: 220;
	
	property var xOrg: 0.65;
	property var yOrg: 3.5;
	
	property var xOff: 0; // text X-Offset
	property var yOff: 0; // text Y-Offset
	property var fPerc: 10; // font size (%)
	property var fScale: 1; // font size (%)
	property var fFace: ""; // font face
	property var iPitch: 0; // instrument's lowest pitch
    property var curScoreName: "";
    property var placement: 0 // 0 above staff 1 below staff


	onRun: {
		txtSize.currentValue = fPerc;
	}
    
    function getNote(pitch){
    switch(pitch){
        case 0: return "C"; break;
        case 1: return "C#"; break;
        case 2: return "D"; break;
        case 3: return "D#"; break;
        case 4: return "E"; break;
        case 5: return "F"; break;
        case 6: return "F#"; break;
        case 7: return "G"; break;
        case 8: return "G#"; break;
        case 9: return "A"; break;
        case 10: return "A#"; break;
        case 11: return "B"; break;
    }
    // "─"
    }

    function getRightButton(note){
    switch(note){
        case "C#5": return ["1a", false, 0]; break;
        case "D#5": return ["1a", true, 0]; break;
        case "A5": return ["2a", false, 0]; break;
        case "G5": return ["2a", true, 0]; break;
        case "G#5": return ["3a", false, 0]; break;
        case "Bb5": return ["3a", true, 0]; break;
        case "C#6": return ["4a", false, 0]; break;
        case "D#6": return ["4a", true, 0]; break;
        case "A6": return ["5a", false, 0]; break;
        case "F6": return ["5a", true, 0]; break;
        case "C5": return ["1", false, 0]; break;
        case "B4": return ["1", true, 0]; break;
        case "E5": return ["2", false, 0]; break;
        case "D5": return ["2", true, 0]; break;
        case "G5": return ["3", false, 0]; break;
        case "F5": return ["3", true, 0]; break;
        case "C6": return ["4", false, 0]; break;
        case "A5": return ["4", true, 0]; break;
        case "E6": return ["5", false, 0]; break;
        case "B5": return ["5", true, 0]; break;
        case "G5": return ["6", false, 0]; break;
        case "F#5": return ["6", true, 0]; break;
        case "B5": return ["7", false, 0]; break;
        case "A5": return ["7", true, 0]; break;
        case "D6": return ["8", false, 0]; break;
        case "C6": return ["8", true, 0]; break;
        case "G6": return ["9", false, 0]; break;
        case "E6": return ["9", true, 0]; break;
        case "B6": return ["10", false, 0]; break;
        case "F#6": return ["10", true, 0]; break;
        default: return [undefined,undefined]
    }
    }
    function getLeftButton(note){
    switch(note){
        case "E3": return ["1a",false, 1]; break;
        case "F3": return ["1a",true, 1]; break;
        case "A3": return ["2a",false, 1]; break;
        case "B♭3": return ["2a",true, 1]; break;
        case "C#4": return ["3a",false, 1]; break;
        case "D#4": return ["3a",true, 1]; break;
        case "A4": return ["4a",false, 1]; break;
        case "G4": return ["4a",true, 1]; break;
        case "G#4": return ["5a",false, 1]; break;
        case "A#4": return ["5a",true, 1]; break;
        case "C3": return ["1",false, 1]; break;
        case "G3": return ["1",true, 1]; break;
        case "G3": return ["2",false, 1]; break;
        case "B3": return ["2",true, 1]; break;
        case "C4": return ["3",false, 1]; break;
        case "D4": return ["3",true, 1]; break;
        case "E4": return ["4",false, 1]; break;
        case "F4": return ["4",true, 1]; break;
        case "G4": return ["5",false, 1]; break;
        case "A4": return ["5",true, 1]; break;
        case "B3": return ["6",false, 1]; break;
        case "A3": return ["6",true, 1]; break;
        case "D4": return ["7",false, 1]; break;
        case "F#4": return ["7",true, 1]; break;
        case "G4": return ["8",false, 1]; break;
        case "A4": return ["8",true, 1]; break;
        case "B4": return ["9",false, 1]; break;
        case "C5": return ["9",true, 1]; break;
        case "D5": return ["10",false, 1]; break;
        case "E5": return ["10",true, 1]; break;
        default: return [undefined,undefined]
    }
    
    }

         function getNoteOctive(pitch){ 
            var output = Math.floor(pitch/12)
            var octive = output - 1
            var note = getNote(pitch - (12 * output))
            return note + octive
         }


         function placeNote(idx, staff, notes){
            var buttonReturn = []
            var text = newElement(Element.STAFF_TEXT);
            text.align = 2;
            text.fontSize = txtSize.currentValue
            var noteNameString = "" 
            var pitch = notes[idx].pitch 
            if (!isNaN(txtCust.currentValue)) {
                pitch += 1*txtCust.currentValue;
            }

            if(staff === 0){
                
               noteNameString = getNoteOctive(pitch)
               buttonReturn = getRightButton(noteNameString)

               if(buttonReturn[0] !== undefined){
                  text.text = `${buttonReturn[1] ? "-\n" : ""}${buttonReturn[0]}`
                  text.offsetY = 9 * idx;
                  text.placement = buttonReturn[2]
               }
               else{
                  buttonReturn = getLeftButton(noteNameString)
                  if(buttonReturn[0] !== undefined)
                     text.text = `${buttonReturn[1] ? "-\n" : ""}${buttonReturn[0]}`
                  else
                     text.text = ``
                  text.offsetY = (9 * idx);
                  text.placement = buttonReturn[2]
               }

            }
            else{
               noteNameString = getNoteOctive(notes[idx].pitch)
               buttonReturn = getLeftButton(noteNameString)
               if(buttonReturn[0] !== undefined)
                  text.text = `${buttonReturn[1] ? "-\n" : ""}${buttonReturn[0]}`
               text.offsetY = (9 * idx);
            }

            // text.fontSize = 8
            return text
         }

    function selectedNote(){

    }   
    function addButtons(){

      curScore.startCmd()

      var cursor = curScore.newCursor()
      var startStaff;
      var endStaff;
      var endTick;
      var fullScore = false;
      cursor.rewind(Cursor.SELECTION_START)

      if(!cursor.segment){
         fullScore = true;
         startStaff = 0;
         endStaff = curScore.nstaves - 1;

      }
      else {
         startStaff = cursor.staffIdx;
         cursor.rewind(Cursor.SELECTION_END)
         if(cursor.tick === 0){
            endTick = curScore.lastSegment.tick + 1;
         }
         else {
            endTick = cursor.tick;
         }
         endStaff = cursor.staffIdx;
      }

      for(var staff = startStaff; staff <= endStaff; staff++){
         for(var voice = 0; voice < 4; voice++){
            cursor.rewind(Cursor.SELECTION_START)
            cursor.voice = voice;
            cursor.staffIdx = staff;

            if(fullScore)
               cursor.rewind(Cursor.SCORE_START)

            while(cursor.segment && (fullScore || cursor.tick < endTick)){
               if(cursor.element && cursor.element.type === Element.CHORD){
                  var notes = cursor.element.notes;
                  var finalNote = 0
                  for(var i = 0; i < notes.length; i++){
                     if(!notes[i].visible)
                        continue
                     var textNode = placeNote(i, staff, notes)
                     finalNote = i
                     cursor.add(textNode);
                  }
               }
               cursor.next()
            }
         }
      }

      curScore.endCmd()
      (typeof(quit) === 'undefined' ? Qt.quit : quit)()
    }
	
	GridLayout {
		id: winUI

		anchors.fill: parent
		anchors.margins: 5
		columns: 2
		columnSpacing: 10
		rowSpacing: 2
		StyledTextLabel {
			id: lblStatus
			text: "WIP"
		}
		StyledTextLabel {
			id: lblDescription
			text: "Working on more functions."
		}
		StyledTextLabel {
			id: lblType
			text: "Layout"
		}
		StyledDropdown {
			id: txtType
			currentIndex: 0
			model: [
				{ 'text': "Wheatstone 30 C/G" },
			]
			onActivated: function(index, value) {
				currentIndex = index
			}
		}

		StyledTextLabel {
			id: lblSize
			text: "Font Size"
		}
		IncrementalPropertyControl {
			id: txtSize
			decimals: 2
			maxValue: 100
			minValue: 1
			step: 1
			currentValue: 10
			implicitWidth: 80
			onValueEdited: function(newValue) {
				currentValue = newValue
			}
		}
		StyledTextLabel {
			id: lblCust
			text: "Transposition"
		}

		IncrementalPropertyControl {
			id: txtCust
			decimals: 0
			maxValue: 12
			minValue: -12
			step: 1
			currentValue: 0
			implicitWidth: 80
			onValueEdited: function(newValue) {
				currentValue = newValue
			}
		}
		FlatButton {
			id: btnApply
			text: "Apply"
			onClicked: addButtons()
		}
		FlatButton {
			id: btnUndo
			text: "Undo"
			onClicked: {cmd("undo");}
		}

	} // GridLayout
}