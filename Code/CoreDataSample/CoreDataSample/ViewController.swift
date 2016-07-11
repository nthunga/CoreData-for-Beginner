//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Naveen Thunga on 11/07/16.
//  Copyright © 2016 My Labs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let context = CoreDataManager.sharedInstance.writeContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func createSchool(sender: AnyObject) {
        let school = School(context:context)
        school.name = "BGS International School"
        school.place = "Bengaluru"
        school.student = nil
        school.teacher = nil
        context.commit()
        print("SCHOOL ADDED SUCCESSFULLY")
        print("===============================================================")
    }
    
    @IBAction func createStudent(sender: AnyObject) {
        let student = Student(context:context)
        student.name = "Tarun Bharath"
        student.id = "08098"
        student.grade = "5th A"
        student.parentName = "Harish Bharath"
        if let school = context.fetchDuplicateObject(School.self, primaryKeyValue: "BGS International School") {
            student.school = school
        }
        context.commit()
        print("STUDENT ADDED SUCCESSFULLY")
        print("===============================================================")
    }
    

    @IBAction func createTeacher(sender: AnyObject) {
        let teacher = Teacher(context:context)
        teacher.name = "Raghavendra Hooda"
        teacher.subjects = ["English","Maths","Hindi"]
        teacher.id = "343"
        if let school = context.fetchDuplicateObject(School.self, primaryKeyValue: "BGS International School") {
            teacher.school = school
        }
        context.commit()
        print("TEACHER ADDED SUCCESSFULLY")
        print("===============================================================")
    }
    
    @IBAction func deleteStudentRecord(sender: AnyObject) {
        if let student = context.fetchDuplicateObject(Student.self, primaryKeyValue: "Tarun Bharath") {
            context.deleteObject(student)
            context.commit()
            print("STUDENT DELETED SUCCESSFULLY")
            print("===============================================================")
        }
    }
    
    @IBAction func showResults(sender: AnyObject) {
        if let results = context.fetch(School) {
            for school in results  {
                if let name = school.name, place = school.place {
                    print("School name = \(name)")
                    print("School place = \(place)")
                }
                
                if let studentList = school.student {
                    for student in studentList {
                        let student = student as? Student
                        if let name = student?.name, id = student?.id {
                            print("Student Details = \(name) \(id)")
                        }
                    }
                }
                
                if let teacherList = school.teacher {
                    for teacher in teacherList {
                        let teacher = teacher as? Teacher
                        if let name = teacher?.name, id = teacher?.id, subjects = teacher?.subjects {
                            print("Teachers Details = \(name) \(id) \(subjects)")
                        }
                    }
                }
            }
            print("===============================================================")
        }
    }
}

