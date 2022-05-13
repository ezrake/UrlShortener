import React from "react";

class UrlForm extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            form: {
                long_url: "",
                short_url: ""
            },
            result: {},
            success: false,
            errors: {}
        }
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(event) {
        this.setState((state) => (
            { form: { ...state.form, [event.target.name]: event.target.value } })
        )
    }

    async handleSubmit(event) {
        event.preventDefault()
        let myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");

        let raw = JSON.stringify(this.state.form);

        let requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: raw,
            redirect: 'follow'
        };

        const response = await fetch("http://127.0.0.1:3000/api/v1/short_url", requestOptions)
        if (!response.ok) {
            response.json()
                .then((errors) => this.setState({ errors: errors }))
        } else {
            response.json()
                .then(result => {
                    this.setState({result: result, success: true})
                })

        }
                
    }
    
    render() {
        return (
            <div>
                <form onSubmit={this.handleSubmit}>
                    <label>Long Url:</label>
                    <input type="text" name="long_url" onChange={this.handleChange}/><br/>
                    <label>Short Url:</label>
                    <input type="text" name="short_url" onChange={this.handleChange} /><br />
                    {!(this.state.errors && Object.keys(this.state.errors).length === 0) &&
                        this.state.errors.short_url.map((error) => {
                            <div>{this.state.form.short_url + ": " + error}</div>
                        })
                    }
                    <input type="submit" value="Submit"/>
                </form>
                {this.state.success && 
                    <p>Success <br />
                        Long Url: {this.state.result.long_url} <br />
                        Short Url: <a href={this.state.result.full_url}>{this.state.result.full_url}</a>
                    </p>
                }
            </div>    
        )
    }
}
export default UrlForm