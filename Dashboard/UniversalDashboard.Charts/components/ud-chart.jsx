import React from 'react';
import {Doughnut, Bar, Line, Polar, Radar, Pie, HorizontalBar, Scatter} from 'react-chartjs-2';
import {withComponentFeatures} from 'universal-dashboard'

const UDCard = (props) => {
    const mapChartData = (element) => {
        var label = element._chart.data.labels[element._index];
        var value = element._chart.data.datasets[element._datasetIndex].data[element._index];

        return {
            ...element._view, 
            label, 
            value
        }
    }

    const onChartClicked = (elements) => {
        if (props.onClick) props.onClick(elements.map(mapChartData))
    }

    var chart = null;
        switch(props.chartType) {
            // Bar
            case "bar":
                chart = <Bar key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Line
            case "line":
                chart = <Line key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Area
            case "area":
                chart = <Polar key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Doughnut
            case "doughnut":
                chart = <Doughnut key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Radar
            case "radar":
            chart = <Radar key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Pie
            case "pie":
            chart = <Pie key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            // Horizontal Bar
            case "horizontalbar":
            chart = <HorizontalBar key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
            case "scatter":
                chart = <Scatter key={"chart" + props.id} data={props.data} options={props.options} onElementsClick={onChartClicked}/>
                break;
        }

        return chart;
}

export default withComponentFeatures(UDCard);