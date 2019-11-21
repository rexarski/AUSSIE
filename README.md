# README

> Scrape course information Australian universities. Although some of them call programs "courses" and call courses "units". Potato, potato, the same thing.

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

## [ANU](https://programsandcourses.anu.edu.au/catalogue)

The content is inserted via JavaScript. So Selenium is required to render information before extracting real data.

In order to navigate to current page for scraping, a user need to click on ***Courses*** in the middle of the page and then navigate to the bottom and click on ***Show all results***. Otherwise, even if you could "see" them all, no data would be extracted as you wish. (Probably you would get an `TypeError: rect is undefined`. This is because you are likely using a correct xpath/css selector/etc. after rendering to find your targets before rendering.)

Execute the commands in `ANU.R`, and a collection of courses would be stored in json format in directory `data`.

## [UMel](https://handbook.unimelb.edu.au/search?types%5B%5D=subject&year=2019&level_type%5B%5D=all&campus_and_attendance_mode%5B%5D=all&org_unit%5B%5D=all&page=1&sort=_score%7Cdesc)

The webpage showing all courses info is paginated. Initially, I thought we need to do these extra steps:

- Accept cookies;
- Get total page numbers;
- Navigate automatically.

With a popup window telling me to accept cookies, I turned myself to Selenium again for help. But it was really painful to deal with an error caused by `remDr$navigate(new_url)`, especailly it kept displaying an `UnknownError` message. Well, the ending of this story is not too bad as I realized I could just keep the popup window hanging. Screw Selenium!

## [USyd](https://sydney.edu.au/courses/search.html)

### Day 1

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

### Day 2

Turns out loading JavaScript takes a while on their webiste. Adding some downtime to each click on the web would be a nice solution.

## UNSW

- http://timetable.unsw.edu.au/2020/subjectSearch.html
- https://www.handbook.unsw.edu.au/

## UQ

## Monash

## UW

## UA

## UC

## Todo

- [x] ANU
- [x] UMel
- [ ] USyd
- [ ] UNSW
- [ ] UQ
- [ ] Monash
- [ ] UW
- [ ] UA
- [ ] UC

## Useful Links

- [Scraping HTML Text](http://bradleyboehmke.github.io/2015/12/scraping-html-text.html)
- 