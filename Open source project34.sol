// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OpenSourceUniversityCourses {

    struct Course {
        uint256 id;
        string title;
        string description;
        address[] enrolledStudents;
        bool isPublished;
    }

    mapping(uint256 => Course) public courses;
    mapping(address => uint256[]) public userCourses;
    uint256 public courseCount;

    // Events
    event CourseCreated(uint256 courseId, string title);
    event StudentEnrolled(uint256 courseId, address student);
    event CourseCompleted(uint256 courseId, address student);

    // Create a new course
    function createCourse(string memory _title, string memory _description) public {
        courseCount++;
        Course storage newCourse = courses[courseCount];
        newCourse.id = courseCount;
        newCourse.title = _title;
        newCourse.description = _description;
        newCourse.isPublished = true;
        
        emit CourseCreated(courseCount, _title);
    }

    // Enroll a student in a course
    function enrollInCourse(uint256 _courseId) public {
        require(courses[_courseId].isPublished, "Course not available");
        courses[_courseId].enrolledStudents.push(msg.sender);
        userCourses[msg.sender].push(_courseId);
        
        emit StudentEnrolled(_courseId, msg.sender);
    }

    // Mark a course as completed by the student
    function completeCourse(uint256 _courseId) public {
        bool enrolled = false;
        for (uint256 i = 0; i < courses[_courseId].enrolledStudents.length; i++) {
            if (courses[_courseId].enrolledStudents[i] == msg.sender) {
                enrolled = true;
                break;
            }
        }
        require(enrolled, "You are not enrolled in this course");

        emit CourseCompleted(_courseId, msg.sender);
    }

    // Get a student's enrolled courses
    function getStudentCourses(address _student) public view returns (uint256[] memory) {
        return userCourses[_student];
    }

    // Get course details
    function getCourse(uint256 _courseId) public view returns (string memory title, string memory description, address[] memory enrolledStudents) {
        Course storage course = courses[_courseId];
        return (course.title, course.description, course.enrolledStudents);
    }
}
