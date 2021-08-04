import React from 'react';
import MonacoEditor, { MonacoDiffEditor }  from 'react-monaco-editor';
import ReactResizeDetector from 'react-resize-detector';
import { withComponentFeatures } from 'universal-dashboard'

var editor;

const UDMonacoEditor = props => {
  const onChange = (newValue) => {
    props.setState({code: newValue})
  }  

  const editorDidMount = (editor, monaco) => {
    editor = editor;
  }

  const onResize = () =>
  {
    if (editor) {
      editor.layout();
    }
  }

  var control = props.original ? 
     
  <MonacoDiffEditor 
     language={props.language}
     theme={props.theme}
     value={props.code}
     original={props.original}
     options={props}
     height={props.height}
     width={props.width}
     onChange={onChange}
     editorDidMount={editorDidMount}/> : 
  
  <MonacoEditor
       language={props.language}
       theme={props.theme}
       value={props.code}
       options={props}
       height={props.height}
       width={props.width}
       onChange={onChange}
       editorDidMount={editorDidMount}/>;

  if (props.autosize)
  {
     return (
       <ReactResizeDetector handleWidth handleHeight onResize={onResize}>
         {control}
       </ReactResizeDetector>
     )
  }

  return control;
}

export default withComponentFeatures(UDMonacoEditor)