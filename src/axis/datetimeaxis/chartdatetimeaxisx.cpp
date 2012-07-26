/****************************************************************************
**
** Copyright (C) 2012 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of the Qt Commercial Charts Add-on.
**
** $QT_BEGIN_LICENSE$
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
** $QT_END_LICENSE$
**
****************************************************************************/

#include "chartdatetimeaxisx_p.h"
#include "chartpresenter_p.h"
#include "qdatetimeaxis.h"
#include <QGraphicsLayout>
#include <QDateTime>
#include <QFontMetrics>
#include <qmath.h>


static int label_padding = 5;

QTCOMMERCIALCHART_BEGIN_NAMESPACE

ChartDateTimeAxisX::ChartDateTimeAxisX(QAbstractAxis *axis,ChartPresenter *presenter) : ChartAxis(axis,presenter),
m_tickCount(0)
{
}

ChartDateTimeAxisX::~ChartDateTimeAxisX()
{
}

void ChartDateTimeAxisX::createLabels(QStringList &labels,qreal min, qreal max, int ticks)
{
    Q_ASSERT(max>min);
    Q_ASSERT(ticks>1);

    QDateTimeAxis *axis = qobject_cast<QDateTimeAxis *>(m_chartAxis);

    int n = qMax(int(-floor(log10((max-min)/(ticks-1)))),0);
    n++;
    for (int i=0; i< ticks; i++) {
        qreal value = min + (i * (max - min)/ (ticks-1));
        labels << QDateTime::fromMSecsSinceEpoch(value).toString(axis->formatString());
    }
}

QVector<qreal> ChartDateTimeAxisX::calculateLayout() const
{
    Q_ASSERT(m_tickCount>=2);

    QVector<qreal> points;
    points.resize(m_tickCount);

    const qreal deltaX = m_rect.width()/(m_tickCount-1);
    for (int i = 0; i < m_tickCount; ++i) {
        int x = i * deltaX + m_rect.left();
        points[i] = x;
    }
    return points;
}

void ChartDateTimeAxisX::updateGeometry()
{
    const QVector<qreal>& layout = ChartAxis::layout();

    m_minWidth = 0;
    m_minHeight = 0;

    if(layout.isEmpty()) return;

    QStringList ticksList;

    createLabels(ticksList,m_min,m_max,layout.size());

    QList<QGraphicsItem *> lines = m_grid->childItems();
    QList<QGraphicsItem *> labels = m_labels->childItems();
    QList<QGraphicsItem *> shades = m_shades->childItems();
    QList<QGraphicsItem *> axis = m_arrow->childItems();

    Q_ASSERT(labels.size() == ticksList.size());
    Q_ASSERT(layout.size() == ticksList.size());

    QGraphicsLineItem *lineItem = static_cast<QGraphicsLineItem*>(axis.at(0));
    lineItem->setLine(m_rect.left(), m_rect.bottom(), m_rect.right(), m_rect.bottom());

    qreal width = 0;
    for (int i = 0; i < layout.size(); ++i) {
        QGraphicsLineItem *lineItem = static_cast<QGraphicsLineItem*>(lines.at(i));
        lineItem->setLine(layout[i], m_rect.top(), layout[i], m_rect.bottom());
        QGraphicsSimpleTextItem *labelItem = static_cast<QGraphicsSimpleTextItem*>(labels.at(i));
            labelItem->setText(ticksList.at(i));
            const QRectF& rect = labelItem->boundingRect();
            QPointF center = rect.center();
            labelItem->setTransformOriginPoint(center.x(), center.y());
            labelItem->setPos(layout[i] - center.x(), m_rect.bottom() + label_padding);

            if(labelItem->pos().x()<=width){
                labelItem->setVisible(false);
                lineItem->setVisible(false);
            }else{
                labelItem->setVisible(true);
                lineItem->setVisible(true);
                width=rect.width()+labelItem->pos().x();
            }
            m_minWidth+=rect.width();
            m_minHeight=qMax(rect.height(),m_minHeight);

        if ((i+1)%2 && i>1) {
            QGraphicsRectItem *rectItem = static_cast<QGraphicsRectItem*>(shades.at(i/2-1));
            rectItem->setRect(layout[i-1],m_rect.top(),layout[i]-layout[i-1],m_rect.height());
        }
        lineItem = static_cast<QGraphicsLineItem*>(axis.at(i+1));
        lineItem->setLine(layout[i],m_rect.bottom(),layout[i],m_rect.bottom()+5);
    }
}

void ChartDateTimeAxisX::handleAxisUpdated()
{
    //TODO:: fix this
    QDateTimeAxis* axis = qobject_cast<QDateTimeAxis*>(m_chartAxis);
    m_tickCount = axis->ticksCount();
    ChartAxis::handleAxisUpdated();
}

QTCOMMERCIALCHART_END_NAMESPACE