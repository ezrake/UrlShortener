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
        this.setState({errors: {}})
        let myHeaders = new Headers();
        myHeaders.append("Content-Type", "application/json");

        let raw = JSON.stringify(this.state.form);

        let requestOptions = {
            method: 'POST',
            headers: myHeaders,
            body: raw,
            redirect: 'follow'
        };

        let host = "https://polar-gorge-50265.herokuapp.com/api/v1/short_url"

        const response = await fetch(host, requestOptions)
        if (!response.ok) {
            response.json()
                .then((errors) => this.setState({ errors: errors, success: false }))
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
                    <input type="submit" value="Submit"/>
                </form>
                {this.state.success && 
                    <p>Success <br />
                        Long Url: {this.state.result.long_url} <br />
                        Short Url: <a href={this.state.result.full_url}>{this.state.result.full_url}</a>
                    </p>
                }
                {Object.keys(this.state.errors).length !== 0 &&
                    Object.keys(this.state.errors).map((errorKey, i) => {
                        return <p key={i}>{errorKey}: <br />
                            {this.state.errors[errorKey].map((error, j) => <span key={j}>{error}</span>)}
                            </p>
                    })
                }
            </div>    
        )
    }
}
export default UrlForm