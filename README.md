# wastewater_particle_filter
Statistical model for combining wastewater data with reported cases to improve estimates of epidemiological quantities

This is a semi-mechanistic model that combines data from reported cases and wastewater sampling to inter the time-varying effective reproduction number and case ascertainment rate. The model is applied to COVID-19 and could be used for other infectious diseases where there is data on reported cases and wastewater sampling.

For more information, see Watson et al. (2023).

### How do I get set up? ###
* Clone this repository to your local directory.
* _model_ contains the model code. The example scipt _main.m_ will run the code with example parameters and plot the outputs. 
* _make_paper_figs_ contains the script files used to make the figures in the manuscript Watson et al. (2023). 
* _data_ contains reported cases and wastewater data for Aotearoa New Zealand up to May 2023. For the most up-to-date data, refer to the Ministry of Health [github page](https://github.com/minhealthnz/nz-covid-data) for case data and the ESR [github page](https://github.com/ESR-NZ/covid_in_wastewater/tree/main/data) for wastewater data. Data from other jurisdictions can be used and the files in this directory illustrate the required format. 

### Who do I talk to? ###
* Leighton Watson: leighton.watson@canterbury.ac.nz
* Michael Plank: michael.plank@canterbury.ac.nz
