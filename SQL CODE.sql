-- create table correct_answer(
-- 	question_paper_code int,
-- 	question_number int,
-- 	correct_option Char(1) Check (correct_option in ('a','b','c','d','e'))
-- );
-- COPY correct_answer FROM 'D:/dump/Dataset_n_Scripts/Dataset_n_Scripts/correct_answer.csv' DELIMITER ',' CSV HEADER;

-- create table question_paper_code(
-- 	paper_code int,
-- 	class int,
-- 	subject varchar
-- );
-- copy question_paper_code from 'D:/dump/Dataset_n_Scripts/Dataset_n_Scripts/question_paper_code.csv' DELIMITER ',' CSV HEADER;
-- create table student_list(
-- 	roll_number int,
-- 	student_name varchar,
-- 	class int,
-- 	section char,
-- 	school_name varchar
-- );
-- copy student_list from 'D:/dump/Dataset_n_Scripts/Dataset_n_Scripts/student_list.csv' DELIMITER ',' CSV HEADER;

-- create table student_response (
-- roll_number int,
-- 	question_paper_code int,
-- 	question_number int,
-- 	option_marked char(1) check (option_marked in ('a','b','c','d','e'))
-- );
-- copy student_response from 'D:/dump/Dataset_n_Scripts/Dataset_n_Scripts/student_response.csv' DELIMITER ',' CSV HEADER;

select * from student_list;
select * from student_response;
select * from correct_answers;
select * from question_paper_code;

with cte as
	(select s_res.roll_number,sl.student_name,sl.class,sl.section,sl.school_name,
		 s_res.question_paper_code,q_code.subject,s_res.question_number, s_res.option_marked, crk.correct_option
	from student_response s_res
	Inner JOIN correct_answers crk
		ON s_res.question_paper_code=crk.question_paper_code and s_res.question_number=crk.question_number
	Inner JOIN question_paper_code q_code
		ON s_res.question_paper_code=q_code.paper_code
	 Inner JOIN student_list sl
	 	ON s_res.roll_number=sl.roll_number
),
marks_calc as(
	select 
	roll_number,student_name,class,section,school_name,
	SUM(case when ((subject='Math') and (option_marked=correct_option)) THEN 1 ELSE 0 END) as math_correct,
	SUM(case when ((subject='Math') and (option_marked<>correct_option) and (option_marked<>'e')) THEN 1 ELSE 0 END) as math_wrong,
	SUM(case when ((subject='Math') and (option_marked='e')) THEN 1 ELSE 0 END) as math_yet_to_learn,
	SUM(case when ((subject='Science') and (option_marked=correct_option)) THEN 1 ELSE 0 END) as science_correct,
	SUM(case when ((subject='Science') and (option_marked<>correct_option) and (option_marked<>'e')) THEN 1 ELSE 0 END) as science_wrong,
	SUM(case when ((subject='Science') and (option_marked='e')) THEN 1 ELSE 0 END) as science_yet_to_learn
	from cte
	group by 1,2,3,4,5
)
select 
	Roll_number,
	Student_name,
	Class,
	Section,
	School_name,
	Math_correct,
	Math_wrong,
	Math_yet_to_learn,
	math_correct as Math_score,
	Round(Math_correct*100/(Math_correct+Math_wrong+Math_yet_to_learn),2) as Math_percentage,
	Science_correct,
	Science_wrong,
	Science_yet_to_learn,
	science_correct as Science_score,
	Round(Science_correct*100/(Science_correct+Science_wrong+Science_yet_to_learn),2) as Science_percentage
from marks_calc;





















