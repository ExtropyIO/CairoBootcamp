# Consortium contract

## Contract overview

A consortium is an association of two or more individuals with the objective of participating in a common activity or pooling their resources for achieving a common goal.

Contract allows people to propose issues, solutions to theses issues and for others to vote on the best solution to a given issue. Chairperson can add new members and propose issues.

## Flow:

**1. Create consortium:** `create_consortium`

Consortium is initialised. Creator become chairperson and a member.

**2. Chairperson adds a new member:**  `add_member`

This action can only be done by the chairperson. Member is initialised.

**3. Proposal is created:** `add_proposal`

This action can only be done by any member that has right to add proposals.

**4. Answer is proposed:** `add_answer`

This action can only be done by a permitted member. Proposal has to allow additions. One member can add only one answer.

**5. Member casts vote:** `vote_answer`

This action can only be done by the member with at least 1 vote who didn't voted on the proposal yet.

**6. Chairperson ends the vote:** `tally`

This action can only be done by the chairperson anytime or by anyone provided vote deadline has expired.

Index of the answer with the highest amount of votes is returned as the winner.

## Features to implement

As in other exercises, functions declarations are provided, their names and parameters are not to be changed as it would break the tests (further). Likewise, tests are not to be changed but can be used for reference.

### Create consortium

Creates consortium with caller as a chairperson. It makes chairperson a member with 100 votes with ability to add proposal and answers.

### Add proposal

Adds a proposal to be voted on. Title, link and answers are arrays. Type s a boolean decided if new answeers can be added. Deadline is a timestamp.

### Add member

### Add answer

### Vote answer

### Tally

Verify caller is chairperson or time has expired
