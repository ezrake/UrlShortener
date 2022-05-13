import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import UrlForm from "../components/UrlForm";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<UrlForm/>} />
    </Routes>
  </Router>
);