/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the Qt Enterprise Charts Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtTest 1.0
import QtCommercial.Chart 1.2

Rectangle {
    width: 400
    height: 300

    TestCase {
        id: tc1
        name: "tst_qml-qtquicktest XY Series 1.2"
        when: windowShown

        function test_properties() {
            verify(lineSeries.color != undefined);
            compare(lineSeries.pointsVisible, false);
            compare(lineSeries.capStyle, Qt.SquareCap);
            compare(lineSeries.style, Qt.SolidLine);
            compare(lineSeries.width, 2.0);

            verify(splineSeries.color != undefined);
            compare(splineSeries.pointsVisible, false);
            compare(splineSeries.capStyle, Qt.SquareCap);
            compare(splineSeries.style, Qt.SolidLine);
            compare(splineSeries.width, 2.0);

            verify(scatterSeries.color != undefined);
            verify(scatterSeries.borderColor != undefined);
            compare(scatterSeries.borderWidth, 2.0);
            compare(scatterSeries.markerShape, ScatterSeries.MarkerShapeCircle);
            compare(scatterSeries.markerSize, 15.0);

            verify(areaSeries.color != undefined);
            verify(areaSeries.borderColor != undefined);
            compare(areaSeries.borderWidth, 2.0);
        }

        function test_axes() {
            // Axis initialization
            compare(chartView.axisX(), lineSeries.axisX);
            compare(chartView.axisY(), lineSeries.axisY);
            compare(lineSeries.axisX, splineSeries.axisX);
            compare(lineSeries.axisY, splineSeries.axisY);
            compare(lineSeries.axisX, areaSeries.axisX);
            compare(lineSeries.axisY, areaSeries.axisY);
        }

        function test_append() {
            lineSeriesPointAddedSpy.clear();
            splineSeriesPointAddedSpy.clear();
            scatterSeriesPointAddedSpy.clear();
            var count = append();
            compare(lineSeries.count, count);
            compare(splineSeries.count, count);
            compare(scatterSeries.count, count);
            compare(lineSeriesPointAddedSpy.count, count);
            compare(splineSeriesPointAddedSpy.count, count);
            compare(scatterSeriesPointAddedSpy.count, count);
            clear();
            compare(lineSeries.count, 0);
            compare(splineSeries.count, 0);
            compare(scatterSeries.count, 0);
        }

        function test_replace() {
            var count = append();
            for (var i = 0; i < count; i++) {
                lineSeries.replace(lineSeries.at(i).x, lineSeries.at(i).y, i, Math.random());
                splineSeries.replace(splineSeries.at(i).x, splineSeries.at(i).y, i, Math.random());
                scatterSeries.replace(scatterSeries.at(i).x, scatterSeries.at(i).y, i, Math.random());
            }
            compare(lineSeries.count, count);
            compare(splineSeries.count, count);
            compare(scatterSeries.count, count);
            compare(lineSeriesPointReplacedSpy.count, count);
            compare(splineSeriesPointReplacedSpy.count, count);
            compare(scatterSeriesPointReplacedSpy.count, count);
            clear();
        }

        function test_insert() {
            var count = append();
            lineSeriesPointAddedSpy.clear();
            splineSeriesPointAddedSpy.clear();
            scatterSeriesPointAddedSpy.clear();
            for (var i = 0; i < count; i++) {
                lineSeries.insert(i * 2, i, Math.random());
                splineSeries.insert(i * 2, i, Math.random());
                scatterSeries.insert(i * 2, i, Math.random());
            }
            compare(lineSeries.count, count * 2);
            compare(splineSeries.count, count * 2);
            compare(scatterSeries.count, count * 2);
            compare(lineSeriesPointAddedSpy.count, count);
            compare(splineSeriesPointAddedSpy.count, count);
            compare(scatterSeriesPointAddedSpy.count, count);
            clear();
        }

        function test_remove() {
            lineSeriesPointRemovedSpy.clear();
            splineSeriesPointRemovedSpy.clear();
            scatterSeriesPointRemovedSpy.clear();
            var count = append();
            for (var i = 0; i < count; i++) {
                lineSeries.remove(lineSeries.at(0).x, lineSeries.at(0).y);
                splineSeries.remove(splineSeries.at(0).x, splineSeries.at(0).y);
                scatterSeries.remove(scatterSeries.at(0).x, scatterSeries.at(0).y);
            }
            compare(lineSeries.count, 0);
            compare(splineSeries.count, 0);
            compare(scatterSeries.count, 0);
            compare(lineSeriesPointRemovedSpy.count, count);
            compare(splineSeriesPointRemovedSpy.count, count);
            compare(scatterSeriesPointRemovedSpy.count, count);
        }

        // Not a test function, called from test functions
        function append() {
            var count = 100;
            chartView.axisX().min = 0;
            chartView.axisX().max = 100;
            chartView.axisY().min = 0;
            chartView.axisY().max = 1;

            for (var i = 0; i < count; i++) {
                lineSeries.append(i, Math.random());
                splineSeries.append(i, Math.random());
                scatterSeries.append(i, Math.random());
            }

            return count;
        }

        // Not a test function, called from test functions
        function clear() {
            lineSeries.clear();
            splineSeries.clear();
            scatterSeries.clear();
        }
    }

    ChartView {
        id: chartView
        anchors.fill: parent

        LineSeries {
            id: lineSeries
            name: "line"

            SignalSpy {
                id: lineSeriesPointAddedSpy
                target: lineSeries
                signalName: "pointAdded"
            }

            SignalSpy {
                id: lineSeriesPointReplacedSpy
                target: lineSeries
                signalName: "pointReplaced"
            }

            SignalSpy {
                id: lineSeriesPointsReplacedSpy
                target: lineSeries
                signalName: "pointsReplaced"
            }

            SignalSpy {
                id: lineSeriesPointRemovedSpy
                target: lineSeries
                signalName: "pointRemoved"
            }
        }

        AreaSeries {
            id: areaSeries
            name: "area"
            upperSeries: lineSeries
        }

        SplineSeries {
            id: splineSeries
            name: "spline"

            SignalSpy {
                id: splineSeriesPointAddedSpy
                target: splineSeries
                signalName: "pointAdded"
            }

            SignalSpy {
                id: splineSeriesPointReplacedSpy
                target: splineSeries
                signalName: "pointReplaced"
            }

            SignalSpy {
                id: splineSeriesPointsReplacedSpy
                target: splineSeries
                signalName: "pointsReplaced"
            }

            SignalSpy {
                id: splineSeriesPointRemovedSpy
                target: splineSeries
                signalName: "pointRemoved"
            }
        }

        ScatterSeries {
            id: scatterSeries
            name: "scatter"

            SignalSpy {
                id: scatterSeriesPointAddedSpy
                target: scatterSeries
                signalName: "pointAdded"
            }

            SignalSpy {
                id: scatterSeriesPointReplacedSpy
                target: scatterSeries
                signalName: "pointReplaced"
            }

            SignalSpy {
                id: scatterSeriesPointsReplacedSpy
                target: scatterSeries
                signalName: "pointsReplaced"
            }

            SignalSpy {
                id: scatterSeriesPointRemovedSpy
                target: scatterSeries
                signalName: "pointRemoved"
            }
        }
    }
}