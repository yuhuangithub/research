SELECT COUNT(*) FROM lagou.`post`;
SELECT * FROM lagou.`post` WHERE job LIKE '%/%';
SELECT cname, COUNT(*) AS post_num FROM lagou.`post` GROUP BY cname ORDER BY post_num DESC INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/company_post_num.txt';
SELECT COUNT(*) FROM lagou.`post` GROUP BY cname;
SELECT COUNT(*) FROM lagou.`post`;
SELECT cid, COUNT(*) AS p_num FROM lagou.`post_top1000` GROUP BY cid ORDER BY p_num;
SELECT publish_date, COUNT(*) AS p_num FROM lagou.`post_top1000` GROUP BY publish_date ORDER BY publish_date;
#truncate company;

SELECT cname, COUNT(*) AS post_num, `cfields`,`csize`,`cpage`,`capital`,`clocation` FROM lagou.`post` GROUP BY cname ORDER BY post_num DESC;

#提取公司信息, 并按post数量取top1000
INSERT INTO `lagou`.`company`
            ( `cname`,
             `post_num`,
             `cfields`,
             `csize`,
             `cpage`,
             `capital`,
             `clocation`)
	SELECT cname, COUNT(*) AS post_num, `cfields`,`csize`,`cpage`,`capital`,`clocation` FROM lagou.`post` GROUP BY cname ORDER BY post_num DESC;

INSERT INTO `lagou`.`company_top1000`
            ( `cname`,
             `post_num`,
             `cfields`,
             `csize`,
             `cpage`,
             `capital`,
             `clocation`)
	SELECT cname, COUNT(*) AS post_num, `cfields`,`csize`,`cpage`,`capital`,`clocation` FROM lagou.`post` GROUP BY cname ORDER BY post_num DESC LIMIT 1000;

SELECT publish_date, COUNT(*) FROM post GROUP BY publish_date ORDER BY publish_date ASC;


SELECT * FROM `company_top1000` ORDER BY cid DESC;
SELECT * FROM `company_top1000` WHERE cid=42 ORDER BY cid DESC;
SELECT * FROM `company_top1000` WHERE cname = '京东世纪贸易有限公司';
SELECT * FROM post WHERE cname = '北京畅游瑞科互联技术有限公司';
SELECT * FROM post_top1000 WHERE description LIKE '%ab %';
SELECT * FROM post WHERE pid =9857;
UPDATE post_top1000 SET description=REPLACE(description, '职位描述', '');

UPDATE `post` SET description='职位描述 职位描述 1、负责蘑菇街Android主客户端的开发及维护； 2、负责蘑菇街TOP Android客户端的开发及维护； 3、负责蘑菇街IM Android客户端的开发及维护； 4、负责推进蘑菇街Android基础架构、公用组件的开发及维护； 职位要求 1、两年以上Java开发经验，一年以上Android开发经验； 2、深入了解Java设计模式、Android系统框架和SDK等； 3、对软件产品有强烈的责任心，具备良好的沟通能力和优秀的团队协作能力； 4、对手机软件性能优化、内存优化有一定经验 5、能独立开发App，有成功发布App者优先. 我们的福利(不限于)： 1、 国家规定的五险一金及补充医疗保险，季度奖，年度奖，每年2次的加薪升职机会哦； 2、 各种带薪假期，每年的免费体检，出国outing ； 3、 人手配备一个mac,2k+的人体工程系椅子，代码写起来刷刷的； 4、 每天品种丰富的免费早餐和加班晚餐；无限制拿的零食、饮料； 5、 大楼里各种免费的娱乐设施：台球，乒乓，桌上足球，xbox ，按摩椅等等；还有免费酒吧，每天调个伏特加神马的也不错； 6、 部门每月的活动经费，方圆10公里内好吃的一网打尽； 7、 妹子比例远超50% ； 8、 优秀人才丰厚的期权奖励；' 
	WHERE pid = 88177;
DELETE FROM post WHERE pid IN (110323,110369,110392,110421,110549,112323,117363,119127,124789);
DELETE FROM post_top1000 WHERE cid IN (575, 869,651,961);
DELETE FROM `company_top1000` WHERE cid IN (575, 869,651,961);

CREATE INDEX cid_index ON `post_terms_top1000`(cid);
SELECT * FROM post_terms_top1000 WHERE cid=1;
SELECT * FROM post_top1000 WHERE cfields LIKE "%招聘%";

SELECT COUNT(*) AS n, industry FROM company_industry WHERE cid<1001 GROUP BY industry ORDER BY n;

#TRUNCATE `company_industry` ;

#TRUNCATE `vocabulary`;
#TRUNCATE `post_terms_top1000`;
#TRUNCATE `company_terms_top1000`;



SELECT * FROM post_top1000 ORDER BY description DESC;

SELECT COUNT(*) FROM vocabulary WHERE frequency<3;


INSERT INTO vocabulary_filter(tid_old,term) SELECT tid,term FROM vocabulary WHERE frequency>2 ORDER BY tid;
UPDATE post_terms_top1000 AS ptt, post_top1000 SET ptt.`publish_date`=post_top1000.`publish_date` WHERE ptt.`pid`=post_top1000.`pid`;
#select cid, count(*) as n from post_top1000 where publish_date>='2014-05-01' and publish_date <= '2015-06-30' group by cid order by n;
SELECT cid, COUNT(*) AS n FROM post_top1000 WHERE  publish_date < '2015-05-01' GROUP BY cid ORDER BY n;
SELECT COUNT(*) FROM post_terms_top1000 WHERE publish_date < '2015-05-01';