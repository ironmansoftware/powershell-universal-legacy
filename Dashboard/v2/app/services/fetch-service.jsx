import {getApiPath, getDashboardId } from './../config.jsx'

const dashboardId = getDashboardId();

export const fetchGet = function(url, success, history, failure) {
    fetch(getApiPath() + url, {
        credentials: 'include',
        headers: {
            'UDConnectionId': UniversalDashboard.connectionId,
            'dashboardId': dashboardId,
            'windowLocation': window.location.href
        }
    })
    .then(function(response){
        UniversalDashboard.invokeMiddleware('GET', url, history, response);

        if (response.status === 200) {

            if (response.headers.has("UDAUTH"))
            {
                window.location = response.headers.get("location");
                return;
            }

            response.text().then(text => {
                try 
                {
                    return JSON.parse(text);    
                }
                catch 
                {
                    return text;   
                }
            }).then(success);
        } else if (response.status == 401) {
            window.location.href = `/login?returnurl=${window.location.pathname}`
        } else {
            throw new Error(response.statusText);
        }
    })
    .catch(function(e) {
        if (failure)
        {
            failure(e);
        }

        console.log(e)
    });
}

export const fetchPost = function(url, data, success) {
    if (!success) {
        success = () => {}
    }

    fetch(getApiPath() + url, {
        method: 'post',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'application/json',
          'UDConnectionId': UniversalDashboard.connectionId,
          'dashboardId': dashboardId
        },
        body: JSON.stringify(data),
        credentials: 'include'
      })
      .then(function(response){
        if (response.status === 200) {
            var jsonresponse = response.json();

            if (jsonresponse == null ) {
                return true;
            }
            else {
                return jsonresponse;
            };
            
        } else {
            throw new Error(response.statusText);
        }
    })
    .then(success)
    .catch(function(e) {
        console.log(e)
    });
}

export const fetchPostFormData = function(url, data, success) {
    if (!success) {
        success = () => {}
    }

    fetch(getApiPath() + url, {
        method: 'post',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'UDConnectionId': UniversalDashboard.connectionId,
          'dashboardId': dashboardId
          //'Content-Type': 'multipart/form-data'
        },
        body: data,
        credentials: 'include'
      })
      .then(function(response){
        if (response.status === 200) {
            return response.json();
        } else {
            throw new Error(response.statusText);
        }
    })
    .then(success)
    .catch(function(e) {
        console.log(e)
    });
}

export const fetchDelete = function(url, data, success) {
    if (!success) {
        success = () => {}
    }

    fetch(getApiPath() + url, {
        method: 'delete',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'application/json',
          'UDConnectionId': UniversalDashboard.connectionId,
          'dashboardId': dashboardId
        },
        body: JSON.stringify(data),
        credentials: 'include'
      })
      .then(function(response){
        if (response.status === 200) {
            return response.json();
        } else {
            throw new Error(response.statusText);
        }
    })
    .then(success)
    .catch(function(e) {
        console.log(e)
    });
}

export const fetchPut = function(url, data, success) {
    if (!success) {
        success = () => {}
    }

    fetch(getApiPath() + url, {
        method: 'put',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'application/json',
          'UDConnectionId': UniversalDashboard.connectionId,
          'dashboardId': dashboardId
        },
        body: JSON.stringify(data),
        credentials: 'include'
      })
      .then(function(response){
        if (response.status === 200) {
            return response.json();
        } else {
            throw new Error(response.statusText);
        }
    })
    .then(success)
    .catch(function(e) {
        console.log(e)
    });
}


export const fetchPostRaw = function(url, data, success) {
    if (!success) {
        success = () => {}
    }

    fetch(getApiPath() + url, {
        method: 'post',
        headers: {
          'Accept': 'application/json, text/plain, */*',
          'Content-Type': 'text/plain',
          'UDConnectionId': UniversalDashboard.connectionId,
          'dashboardId': dashboardId
        },
        body: data,
        credentials: 'include'
      })
      .then(function(response){
        if (response.status === 200) {
            return response.text();
        } else {
            throw new Error(response.statusText);
        }
    })
    .then(success)
    .catch(function(e) {
        console.log(e)
    });
}
