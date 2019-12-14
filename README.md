# README

> Scrape course information Australian universities. Although some of them call programs "courses" and call courses "units". Potato, potato, the same thing.

**The result is saved in `aus-uni.json`.**

## Setup

To install [RSelenium](https://github.com/ropensci/RSelenium) via Docker, please refer its installation guide.

To start Selenium, use the following command:

```bash
docker run -d -p 4445:4444 selenium/standalone-firefox
```

To stop Selenium, use this:

```bash
docker stop [container_id]
```

## Todo
  
- [x] [ANU](https://programsandcourses.anu.edu.au/catalogue)
- [x] [University of Melbourne](https://handbook.unimelb.edu.au/search?types%5B%5D=subject&year=2019&level_type%5B%5D=all&campus_and_attendance_mode%5B%5D=all&org_unit%5B%5D=all&page=1&sort=_score%7Cdesc)
- [x] [University of Sydney](https://sydney.edu.au/courses/search.html), [source 2](https://www.timetable.usyd.edu.au/uostimetables/2020/)
- [x] [University of New South Wales](http://timetable.unsw.edu.au/2020/subjectSearch.html)
- [x] [University of Queensland](https://my.uq.edu.au/programs-courses/browse.html?level=ugpg) 
- [x] [Monash University](http://www.monash.edu/pubs/2019handbooks/units/index-bycode.html)
- [x] [University of Adelaide](https://www.adelaide.edu.au/course-outlines/)
- [x] [University of Western Australia](https://handbooks.uwa.edu.au/search?type=units)
- [x] [RMIT](https://www.rmit.edu.au/content/dam/rmit/documents/staff-site/servicesandtools/finance/2020-HE-course-list.pdf)
- [x] [Deakin University](https://www.deakin.edu.au/courses-search/unit-search.php?hidCurrentYear=2020&hidYear=2020&hidType=max&txtUnit=&txtTitle=&txtKeyword=&selLevel=Select&selSemester=Select&selMode=Select&selLocation=B&chkSortby=unit_cd&btnSubmit=)
- [x] [Victoria University](https://www.vu.edu.au/courses/search?iam=resident&query=&type=Unit)
- [x] [Bond University](https://bond.edu.au/current-students/study-information/subjects?type=1&area=All)
- [x] [Curtin University](http://handbook.curtin.edu.au/unitSearch.html)
- [x] [Griffith University](https://www.griffith.edu.au/study/courses)
- [x] [Murdoch University](http://handbook.murdoch.edu.au/units/?year=2020&sort=UnitCd)
- [x] [Southern Cross University](https://www.scu.edu.au/study-at-scu/unit-search/?year=2020)
- [x] [University of Newcastle](https://www.newcastle.edu.au/course)
- [x] [University of Wollongong](https://solss.uow.edu.au/sid/cal.USER_CALENDAR_SELECT_SCREEN?p_cal_types=UP&p_breadcrumb_type=1&p_menu_type=1&p_cs=8794042783047766832)
- [x] [University of Sunshine Coast](https://www.usc.edu.au/learn/courses-and-programs/courses/search-for-usc-courses?courseCode=&keyword=&teachingPeriodOfOffer=Semester+1&school=&offeredLocations=&submit=Search&searchType=coursesonly#coursesonly)

**Data from the following unis are scraped by my colleague:

- University of Technology Sydney
- University of Canberra
- Queensland University of Technology
- La Trobe University
- Macquarie University
- [University of Tasmania](https://www.utas.edu.au/courses/unit-search?query=&collection=handbook-meta&clive=handbook-units&sort=&meta_B_and=&meta_A_and=&meta_F_phrase_and=&meta_M_phrase_and=&meta_J_phrase_and=&meta_unitYear=2020&meta_D_phrase_and=&meta_U_phrase_and=&meta_N_phrase_and=&meta_E_phrase_and=&meta_V_phrase_and=)

## Comments

### The Australian National University

The content is inserted via JavaScript. So Selenium is required to render information before extracting real data.

In order to navigate to current page for scraping, a user need to click on ***Courses*** in the middle of the page and then navigate to the bottom and click on ***Show all results***. Otherwise, even if you could "see" them all, no data would be extracted as you wish. (Probably you would get an `TypeError: rect is undefined`. This is because you are likely using a correct xpath/css selector/etc. after rendering to find your targets before rendering.)

Execute the commands in `ANU.R`, and a collection of courses would be stored in json format in directory `data`.

### University of Melbourne

The webpage showing all courses info is paginated. Initially, I thought we need to do these extra steps:

- Accept cookies;
- Get total page numbers;
- Navigate automatically.

With a popup window telling me to accept cookies, I turned myself to Selenium again for help. But it was really painful to deal with an error caused by `remDr$navigate(new_url)`, especailly it kept displaying an `UnknownError` message. Well, the ending of this story is not too bad as I realized I could just keep the popup window hanging. Screw Selenium!

### University of Sydney

#### Day 1

Different error every time.

Error Message:

```
Selenium message:Browsing context has been discarded
Build info: version: '3.141.59', revision: 'e82be7d358', time: '2018-11-14T08:25:53'
System info: host: '7de870fafffd', ip: '172.17.0.2', os.name: 'Linux', os.arch: 'amd64', os.version: '4.9.184-linuxkit', java.version: '1.8.0_222'
Driver info: driver.version: unknown

Error: 	 Summary: NoSuchWindow
 	 Detail: A request to switch to a different window could not be satisfied because the window could not be found.
 	 class: org.openqa.selenium.NoSuchWindowException
	 Further Details: run errorDetails method
```

Error message 2:

```
Selenium message:Unable to locate element: #b-js-course-search-results-uos > div:nth-child(1) > div:nth-child(3) > a:nth-child(7)
For documentation on this error, please visit: https://www.seleniumhq.org/exceptions/no_such_element.html
Build info: version: '3.141.59', revision: 'e82be7d358', time: '2018-11-14T08:25:53'
System info: host: '7de870fafffd', ip: '172.17.0.2', os.name: 'Linux', os.arch: 'amd64', os.version: '4.9.184-linuxkit', java.version: '1.8.0_222'
Driver info: driver.version: unknown

Error: 	 Summary: NoSuchElement
 	 Detail: An element could not be located on the page using the given search parameters.
 	 class: org.openqa.selenium.NoSuchElementException
	 Further Details: run errorDetails method
```

#### Day 2

Turns out loading JavaScript takes a while on their website. Adding some downtime to each click on the web would be a nice solution.

#### Update on 2019-12-13

At some point, the data on this site has been changed. So I wrote a new crawler to replace the previous one. But still, Selenium was utilized during this process.

But the problem still remains as some pages contain "nothing" to scrape. Eventually, I came up with a potential solution of a manual "try-catch": if nothing is scraped, repeat until something is retrieved.

#### Update on 2019-12-14

It is quite weird that none of the financial units could be seen in the list, but they were de facto existing in the search result. In order to jump out of this paradox, I found another page which only contains html table in it. I scraped it and took the union of today's data and the previous one. Done.

### University of New South Wales

The only thing worth mentioning is different subject pages might contain different number of "sections". Some area of subject has three sections: *undergraduate, postgraduate* and *research*. But some only has one.

### University of Queensland

This one is straightforward and tricky at the same time. The target urls to scrape are not in the same form all the way. Pay attention to this.

There are 3 different types of program pages:

- The normal ones with normal urls to course lists;
- The ones with different urls to course lists;
- The ones without any detailed course lists.

Additionally, there are some program pages, though directing to an existing course list page, but it contains nothing substantial.

> Starting from program "Agribusiness" the course list url shifts from:
> https://my.uq.edu.au/programs-courses/plan_display.html?acad_plan=[program-code]
> to
> https://my.uq.edu.au/programs-courses/program_list.html?acad_prog=[program-code]
> then probably it's better to get the exact url from previous page instead of "putting them together"
> also major_data is different in the second type of webpage

### RMIT

RMIT is the only uni so far that requires a document analysis (kinda). Thanks to the formality of a table (in fact, multiple tables), it is not painful to extract all of them.

### Deakin

On the contrary, I first thought Deakin's data is only contained in its corresponding pdf version handbook. That was really a PITA (guess what does this mean?) because although a toc is two-column, the data scraped is not. So matching left data from the left column and its leftovers onto the next line is even impossible. It feels really confusing even now I'm describing this to you and to myself. Just forget about it, I eventually figured out where to scrape the data.

### Griffith

the lazy loading mechanics (if i'm correct) is really annoying in [this website](https://www.griffith.edu.au/study/courses).

In detail, if we dive into the developer console of web browser, the secret is unveiled: each time we scroll to the end of this page, an additional 500 results will be rendered after a few seconds. So the best practice here is to directly get the response as json, dump them locally and deal with them later.

A response url looks like [this](https://www.griffith.edu.au/_designs/search/degree-search?num_ranks=500&start_rank=2001&collection=courses-api) and we can modify the parameters to catch them all at the same time!

The next step is to deal with json file ;)

### USC

Search results only contain top 50 out of all results. :( Why? It's impossible to extract all data if the data itself is kept secret.

## Useful Links

- [Scraping HTML Text](http://bradleyboehmke.github.io/2015/12/scraping-html-text.html)
- [Convert a list to a data frame](https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame)
- [R grep pattern regex with brackets](https://stackoverflow.com/questions/7992436/r-grep-pattern-regex-with-brackets)
- [strsplit with vertical bar](https://stackoverflow.com/questions/23193219/strsplit-with-vertical-bar-pipe)
- [Remove a subset of records from a dataframe in r](https://stackoverflow.com/questions/38759429/remove-a-subset-of-records-from-a-dataframe-in-r)
- [Merge extra contents to the left when splitting one column to two with multiple delimiters](https://stackoverflow.com/questions/33109799/merge-extra-contents-to-the-left-when-splitting-one-column-to-two-with-multiple)
- [How to split a string from right-to-left, like Python's rsplit()?](https://stackoverflow.com/questions/20454768/how-to-split-a-string-from-right-to-left-like-pythons-rsplit)
- [Why is message() a better choice than print() in R for writing a package?](https://stackoverflow.com/questions/36699272/why-is-message-a-better-choice-than-print-in-r-for-writing-a-package/36700294)
- [How to extract date from a multiline string or File in R](https://stackoverflow.com/questions/58156097/how-to-extract-date-from-a-multiline-string-or-file-in-r)
