import React, { useEffect, useState } from "react";
import ReactPaginate from 'react-paginate';
import axios from 'axios';

export default () => {
  // List of fetched companies
  const [companies, setCompanies] = useState([]);

  const [page, setPage] = useState(0);
  const [totalPages, setTotalPages] = useState(1);

  const [errors, setErrors] = useState(null);

  // Table filters
  const [companyName, setCompanyName] = useState("");
  const [industry, setIndustry] = useState("");
  const [minEmployee, setMinEmployee] = useState("");
  const [minimumDealAmount, setMinimumDealAmount] = useState("");

  const handlePageChange = (selectedPage) => {
    setPage(selectedPage.selected + 1);
  };

  const validateForSpecialChars = () => {
    var format = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]+/;

    if(format.test(companyName) || format.test(industry)){
      return true;
    } else {
      return false;
    }
  }

  const constructParams = () => {
    var params = {
      page: page,
      name: companyName,
      industry: industry,
      min_employee_count: minEmployee,
      minimum_deal_amount: minimumDealAmount
    }

    return params;
  }

  const fetchCompanies = () => {
    if (validateForSpecialChars()){
      setErrors(["Only letters and numbers allowed for company name & industry"]);
      return;
    } else {
      setErrors(null);
    }
    const params = constructParams();
    const url = `/api/v1/companies`;
    axios.get(url, { params: params })
      .then((response) => {
        setCompanies(response.data.companies);
        setTotalPages(response.data.total_pages);
      })
      .catch(error => {
        setErrors(error.response.data.error_messages)
      });
  };

  useEffect(() => {
    fetchCompanies();
  }, [page, companyName, industry, minEmployee, minimumDealAmount])

  return (
    <div className="vw-100 primary-color align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Companies</h1>

          <label htmlFor="company-name">Company Name</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="company-name" value={companyName} onChange={e => setCompanyName(e.target.value)} />
          </div>

          <label htmlFor="industry">Industry</label>
          <div className="input-group mb-3">
            <input type="text" className="form-control" id="industry" value={industry} onChange={e => setIndustry(e.target.value)} />
          </div>

          <label htmlFor="min-employee">Minimum Employee Count</label>
          <div className="input-group mb-3">
            <input type="number" min="0" className="form-control" id="min-employee" value={minEmployee} onChange={e => setMinEmployee(e.target.value)} />
          </div>

          <label htmlFor="min-amount">Minimum Deal Amount</label>
          <div className="input-group mb-3">
            <input type="number" min="0" className="form-control" id="min-amount" value={minimumDealAmount} onChange={e => setMinimumDealAmount(e.target.value)} />
          </div>
          {errors && <div className="alert alert-danger" role="alert">
            {errors}
          </div>}

          {!errors && <table className="table">
            <thead>
              <tr>
                <th scope="col">Name</th>
                <th scope="col">Industry</th>
                <th scope="col">Employee Count</th>
                <th scope="col">Total Deal Amount</th>
              </tr>
            </thead>
            <tbody>
              {companies?.map((company) => (
                <tr key={company.id}>
                  <td>{company.name}</td>
                  <td>{company.industry}</td>
                  <td>{company.employee_count}</td>
                  <td>{company.deals_amount || 0}</td>
                </tr>
              ))}
            </tbody>
          </table>}

          {!errors &&<ReactPaginate
            initialPage={page}
            pageCount={totalPages}
            onPageChange={handlePageChange}
            containerClassName="pagination"
            activeClassName="active"
            disableInitialCallback={true}
          />}
        </div>
      </div>
    </div>
  )
};
