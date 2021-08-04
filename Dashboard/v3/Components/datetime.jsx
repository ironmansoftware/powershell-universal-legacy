import React from 'react';
var dayjs = require('dayjs')
var localizedFormat = require('dayjs/plugin/localizedFormat')
var relativeTime = require('dayjs/plugin/relativeTime')
dayjs.extend(relativeTime)
dayjs.extend(localizedFormat)

const DayTime = (props) => {
    return dayjs(props.inputObject).format(props.format);
}

export default DayTime;

