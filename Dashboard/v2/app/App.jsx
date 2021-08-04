import React from 'react';
import UdDashboard from './ud-dashboard.jsx'
import {
    BrowserRouter as Router,
    Route
} from 'react-router-dom'
import {getApiPath} from './config.jsx';
import Spinner from 'react-spinkit';
import ErrorCard from '../Components/error-card.jsx';

export default class App extends React.Component {

    constructor() {
        super();

        this.state = {
            loading: true,
            loadingMessage: 'Loading framework...',
            error: null,
            errorInfo: null
        }
    }

    loadJavascript(url, onLoad) {
        var jsElm = document.createElement("script");
        jsElm.onload = onLoad;
        jsElm.type = "application/javascript";
        jsElm.src = url;
        document.body.appendChild(jsElm);
    }

    componentWillMount() {
        this.setState({
            loading: false
        })
    }

    componentDidCatch(error, errorInfo) {
        this.setState({
            error,
            errorInfo
        })
    }

    render () {
        
        if (this.state.error) {
            return <ErrorCard message={this.state.error && this.state.error.toString()} location={this.state.errorInfo.componentStack} />
        }

        if (this.state.loading) {
            return <div style={{backgroundColor: '#FFFFFF'}} className="v-wrap">
                        <article className="v-box">
                            <Spinner name="folding-cube" style={{width: '150px', height: '150px', color: '#0689B7'}}/>
                        </article>
                        
                    </div>
        }

        var pluginRoutes = UniversalDashboard.provideRoutes();

        return (<Router basename={window.baseUrl}>
                <div className="ud-dashboard">
                    {pluginRoutes}
                    <Route path="/" component={UdDashboard} />
                </div>
            </Router> )
  }
}
