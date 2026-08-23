import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Shapes

ShellRoot {
  id: root

  readonly property color background: "#24283b"
  readonly property color surface: "#1f2335"
  readonly property color border: "#414868"
  readonly property color foreground: "#c0caf5"
  readonly property color muted: "#565f89"
  readonly property color blue: "#7aa2f7"
  readonly property color cyan: "#7dcfff"
  readonly property color magenta: "#bb9af7"
  readonly property string fontFamily: "Iosevka Nerd Font Mono"

  property real downloadRate: 0
  property real uploadRate: 0
  property double previousRx: -1
  property double previousTx: -1
  property double previousSampleTime: 0

  function sampleNetwork(contents: string): void {
    let rx = 0;
    let tx = 0;

    for (const line of contents.split("\n").slice(2)) {
      const parts = line.trim().split(/[:\s]+/);
      if (parts.length < 10 || parts[0] === "lo")
        continue;

      rx += Number(parts[1]);
      tx += Number(parts[9]);
    }

    const now = Date.now();
    const elapsed = (now - previousSampleTime) / 1000;
    if (previousRx >= 0 && elapsed > 0) {
      downloadRate = Math.max(0, (rx - previousRx) / elapsed);
      uploadRate = Math.max(0, (tx - previousTx) / elapsed);
    }

    previousRx = rx;
    previousTx = tx;
    previousSampleTime = now;
  }

  function formatRate(bytes: real): string {
    if (bytes >= 1073741824)
      return (bytes / 1073741824).toFixed(1) + " GiB/s";
    if (bytes >= 1048576)
      return (bytes / 1048576).toFixed(1) + " MiB/s";
    if (bytes >= 1024)
      return (bytes / 1024).toFixed(1) + " KiB/s";
    return Math.round(bytes) + " B/s";
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  PwObjectTracker {
    objects: [Pipewire.defaultAudioSink]
  }

  FileView {
    id: networkStats
    path: "/proc/net/dev"
    printErrors: true
    onLoaded: root.sampleNetwork(this.text())
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: networkStats.reload()
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: bar
        required property var modelData

        screen: modelData
        color: root.background
        implicitHeight: 32
        exclusiveZone: 32

        anchors {
          top: true
          left: true
          right: true
        }

        Rectangle {
          anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
          }
          height: 1
          color: root.border
        }

        Row {
          id: workspaces
          anchors {
            left: parent.left
            leftMargin: 12
            verticalCenter: parent.verticalCenter
          }
          spacing: 6

          Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
              id: workspace
              required property var modelData

              readonly property bool onThisMonitor: modelData.lastIpcObject
                && modelData.lastIpcObject.monitor === bar.screen.name

              visible: onThisMonitor && !modelData.name.startsWith("special:")
              width: visible ? 24 : 0
              height: 22
              radius: 6
              color: modelData.focused ? root.blue : modelData.active ? root.magenta : root.surface
              border.width: modelData.focused || modelData.active ? 0 : 1
              border.color: modelData.urgent ? root.magenta : root.border

              Text {
                anchors.centerIn: parent
                text: workspace.modelData.name
                color: workspace.modelData.focused || workspace.modelData.active ? root.surface : root.foreground
                font.family: root.fontFamily
                font.pixelSize: 12
                font.weight: Font.DemiBold
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: workspace.modelData.activate()
              }

              Behavior on color {
                ColorAnimation { duration: 140 }
              }
            }
          }
        }

        Rectangle {
          anchors.centerIn: parent
          width: timeText.implicitWidth + 28
          height: 22
          radius: 7
          color: root.surface
          border.width: 1
          border.color: root.border

          Text {
            id: timeText
            anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "ddd d MMM  h:mm:ss AP")
            color: root.foreground
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.DemiBold
          }
        }

        Row {
          anchors {
            right: parent.right
            rightMargin: 12
            verticalCenter: parent.verticalCenter
          }
          spacing: 6

          Rectangle {
            width: networkRow.implicitWidth + 22
            height: 22
            radius: 7
            color: root.surface
            border.width: 1
            border.color: root.border

            Row {
              id: networkRow
              anchors.centerIn: parent
              spacing: 12

              Text {
                text: "󰇚  " + root.formatRate(root.downloadRate)
                color: root.cyan
                font.family: root.fontFamily
                font.pixelSize: 11
                font.weight: Font.Medium
              }

              Text {
                text: "󰕒  " + root.formatRate(root.uploadRate)
                color: root.magenta
                font.family: root.fontFamily
                font.pixelSize: 11
                font.weight: Font.Medium
              }
            }
          }

          Rectangle {
            id: audioButton
            width: 26
            height: 22
            radius: 7
            color: audioPopup.visible ? root.blue : root.surface
            border.width: audioPopup.visible ? 0 : 1
            border.color: root.border

            Text {
              anchors.centerIn: parent
              text: "󰋋"
              color: audioPopup.visible ? root.surface
                : Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.muted ? root.muted
                : root.blue
              font.family: root.fontFamily
              font.pixelSize: 13
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: audioPopup.visible = !audioPopup.visible
            }

            Behavior on color {
              ColorAnimation { duration: 120 }
            }
          }
        }

        PopupWindow {
          id: audioPopup
          anchor.window: bar
          anchor.rect.x: bar.width - width - 12
          anchor.rect.y: bar.height - 4
          implicitWidth: 250
          implicitHeight: 108
          color: "transparent"
          grabFocus: true

          Item {
            id: audioSurface
            anchors.fill: parent
            transformOrigin: Item.TopRight
            scale: audioPopup.visible ? 1 : 0.88
            opacity: audioPopup.visible ? 1 : 0

            Shape {
              anchors.fill: parent
              antialiasing: true

              ShapePath {
                fillColor: root.background
                strokeColor: root.border
                strokeWidth: 1
                joinStyle: ShapePath.RoundJoin
                startX: 224
                startY: 0

                PathLine { x: 250; y: 0 }
                PathLine { x: 250; y: 96 }
                PathQuad { x: 238; y: 108; controlX: 250; controlY: 108 }
                PathLine { x: 12; y: 108 }
                PathQuad { x: 0; y: 96; controlX: 0; controlY: 108 }
                PathLine { x: 0; y: 26 }
                PathQuad { x: 12; y: 14; controlX: 0; controlY: 14 }
                PathLine { x: 202; y: 14 }
                PathCubic {
                  x: 224
                  y: 0
                  control1X: 213
                  control1Y: 14
                  control2X: 224
                  control2Y: 7
                }
              }
            }

            Behavior on scale {
              NumberAnimation { duration: 220; easing.type: Easing.OutBack }
            }

            Behavior on opacity {
              NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
            }

            Text {
              anchors {
                top: parent.top
                left: parent.left
                topMargin: 27
                leftMargin: 16
              }
              text: "OUTPUT"
              color: root.muted
              font.family: root.fontFamily
              font.pixelSize: 10
              font.weight: Font.DemiBold
              font.letterSpacing: 1.2
            }

            Text {
              anchors {
                top: parent.top
                right: parent.right
                topMargin: 26
                rightMargin: 16
              }
              text: Pipewire.defaultAudioSink
                ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
                : "--"
              color: root.cyan
              font.family: root.fontFamily
              font.pixelSize: 12
              font.weight: Font.DemiBold
            }

            Row {
              anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                leftMargin: 14
                rightMargin: 16
                bottomMargin: 13
              }
              spacing: 12

              Rectangle {
                id: muteButton
                width: 30
                height: 30
                radius: 9
                color: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.muted
                  ? root.magenta : root.surface
                border.width: 1
                border.color: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.muted
                  ? root.magenta : root.border

                Text {
                  anchors.centerIn: parent
                  text: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.muted ? "󰝟" : "󰕾"
                  color: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio.muted
                    ? root.surface : root.foreground
                  font.family: root.fontFamily
                  font.pixelSize: 14
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  enabled: Pipewire.defaultAudioSink !== null
                  onClicked: Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
                }
              }

              Item {
                id: volumeSlider
                width: parent.width - muteButton.width - parent.spacing
                height: 30

                readonly property real value: Pipewire.defaultAudioSink
                  ? Math.min(1, Pipewire.defaultAudioSink.audio.volume) : 0

                Rectangle {
                  anchors.verticalCenter: parent.verticalCenter
                  width: parent.width
                  height: 5
                  radius: 3
                  color: root.surface
                  border.width: 1
                  border.color: root.border

                  Rectangle {
                    width: parent.width * volumeSlider.value
                    height: parent.height
                    radius: parent.radius
                    color: root.blue
                  }
                }

                Rectangle {
                  x: Math.max(0, Math.min(parent.width - width, parent.width * volumeSlider.value - width / 2))
                  anchors.verticalCenter: parent.verticalCenter
                  width: 12
                  height: 12
                  radius: 6
                  color: root.foreground
                  border.width: 2
                  border.color: root.blue
                }

                MouseArea {
                  anchors.fill: parent
                  cursorShape: Qt.PointingHandCursor
                  enabled: Pipewire.defaultAudioSink !== null

                  function setVolume(mouseX: real): void {
                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, mouseX / width));
                  }

                  onPressed: mouse => setVolume(mouse.x)
                  onPositionChanged: mouse => {
                    if (pressed)
                      setVolume(mouse.x);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
