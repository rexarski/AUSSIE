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
