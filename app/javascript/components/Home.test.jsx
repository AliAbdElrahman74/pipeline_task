/**
 * @jest-environment jsdom
 */

import React from 'react';
import { act, render, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';

import Home from './Home';

describe('Home', () => {
  let mock;

  beforeEach(() => {
    mock = new MockAdapter(axios);
  });

  afterEach(() => {
    mock.restore();
  });

  let companies = [
    { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
    { id: 2, name: 'Company 2', industry: 'Finance', employee_count: 200, deals_amount: 2000 },
  ];

  it('renders without crashing', () => {
    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });
    render(<Home />);
  });

  it('fetches companies on component mount', async () => {
    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
        companies, total_pages: 1
    });

    const { findByText } = render(<Home />);
    const company1 = await findByText('Company 1');
    const company2 = await findByText('Company 2');

    expect(company1).toBeInTheDocument();
    expect(company2).toBeInTheDocument();
  });

  it('displays error message if fetch fails', async () => {
    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(500, {
      error_message: 'Something went wrong, please try again later'
    });

    const { findByText } = render(<Home />);
    const errorMessage = await findByText('Something went wrong, please try again later');

    expect(errorMessage).toBeInTheDocument();
  });

  it('displays filtered companies based on name', async () => {
    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
      { id: 1, name: 'Name 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=C&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    const { getByLabelText, findByText, queryByText } = render(<Home />);
    fireEvent.change(getByLabelText('Company Name'), { target: { value: 'C' } });

    const company1 = await findByText('Company 1');
    expect(company1).toBeInTheDocument();

    const company2 = await queryByText('Name 1');
    expect(company2).not.toBeInTheDocument(); 
  });

  it('displays filtered companies based on industry', async () => {
    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
      { id: 1, name: 'Company 2', industry: 'Education', employee_count: 100, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=T&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    const { getByLabelText, findByText, queryByText } = render(<Home />);
    fireEvent.change(getByLabelText('Industry'), { target: { value: 'T' } });

    const company1 = await findByText('Company 1');
    expect(company1).toBeInTheDocument();

    const company2 = await queryByText('Company 2');
    expect(company2).not.toBeInTheDocument(); 
  });

  it('displays filtered companies based on min employee count', async () => {
    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 101, deals_amount: 1000 },
      { id: 1, name: 'Company 2', industry: 'Technology', employee_count: 99, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=100&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    const { getByLabelText, findByText, queryByText } = render(<Home />);
    fireEvent.change(getByLabelText('Minimum Employee Count'), { target: { value: '100' } });

    const company1 = await findByText('Company 1');
    expect(company1).toBeInTheDocument();

    const company2 = await queryByText('Company 2');
    expect(company2).not.toBeInTheDocument(); 
  });

  it('displays filtered companies based on min deal amount', async () => {
    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 101, deals_amount: 1001 },
      { id: 1, name: 'Company 2', industry: 'Technology', employee_count: 99, deals_amount: 999 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 1
    });

    companies = [
      { id: 1, name: 'Company 1', industry: 'Technology', employee_count: 101, deals_amount: 1001 },
    ];

    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=1000').reply(200, {
      companies, total_pages: 1
    });

    const { getByLabelText, findByText, queryByText } = render(<Home />);
    fireEvent.change(getByLabelText('Minimum Deal Amount'), { target: { value: '1000' } });

    const company1 = await findByText('Company 1');
    expect(company1).toBeInTheDocument();

    const company2 = await queryByText('Company 2');
    expect(company2).not.toBeInTheDocument(); 
  });

  it('paginates companies correctly', async () => {
    mock.onGet('/api/v1/companies?page=0&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 2
    });

    companies = [
      { id: 3, name: 'Company 3', industry: 'Technology', employee_count: 100, deals_amount: 1000 },
      { id: 4, name: 'Company 4', industry: 'Finance', employee_count: 200, deals_amount: 2000 },
    ];

    mock.onGet('/api/v1/companies?page=2&name=&industry=&min_employee_count=&minimum_deal_amount=').reply(200, {
      companies, total_pages: 2 
    });

    const { findByText } = render(<Home />);
  
    fireEvent.click(await findByText('2'));

    const company1 = await findByText('Company 3');
    const company2 = await findByText('Company 4');

    expect(company1).toBeInTheDocument();
    expect(company2).toBeInTheDocument();
  });
});
