# Universal Dashboard Components and Frameworks

This folder contains Universal Dashboard components and frameworks for use within PowerShell Universal. 

# Building

You can build frameworks by using `Invoke-Build`. Node JS is also required to build the JavaScript components. 

You can build individual components and frameworks by navigating to their directory and then invoking a build. 

```
cd v3 
Invoke-Build 
```

# Installing

Once you have built a component, the package will be available in the output directory for that item. You can copy that to `%ProgramData%\PowerShellUniversal\Dashboard`. You'll have to restart PowerShell Universal for it to read the new component or framework. 

# Contributing

We accept pull requests on this repository. Please submit issues on the [https://github.com/ironmansoftware/issues](issues) repository. 

