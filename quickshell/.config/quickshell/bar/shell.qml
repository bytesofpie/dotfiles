import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

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

              visible: onThisMonitor
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
            text: Qt.formatDateTime(clock.date, "ddd d MMM  HH:mm:ss")
            color: root.foreground
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.DemiBold
          }
        }

        Rectangle {
          anchors {
            right: parent.right
            rightMargin: 12
            verticalCenter: parent.verticalCenter
          }
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
      }
    }
  }
}
