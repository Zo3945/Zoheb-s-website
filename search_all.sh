#!/bin/bash

# Update About.js with SearchHighlight
cat > src/components/About.js << 'EOF'
import React from 'react';
import { useScrollAnimation, useCountUp } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './About.css';

const BIO = "Born and raised in New York, I'm a Computer Science rising senior at Pace University who loves seeing ideas come to life through code. Whether it's a mobile app, a web tool, or something in between, there's nothing better than building something from scratch and watching it actually work. Outside of school I stay active lifting and playing sports, and that same drive carries into everything I build. I got into CS because I wanted to create things that make an impact, and that's still what pushes me every day.";

const HIGHLIGHTS = [
  { label: 'Pace University', icon: '🎓' },
  { label: 'SWE Intern Experience', icon: '💼' },
  { label: 'Best Website Award — WiCyS', icon: '🏆' },
  { label: 'Android Developer', icon: '📱' },
];

function StatCard({ number, label, visible }) {
  const count = useCountUp(number, visible);
  return (
    <div className="stat-card">
      <span className="stat-card__num">{visible ? count || number : '0'}</span>
      <span className="stat-card__label">{label}</span>
    </div>
  );
}

function About({ searchQuery }) {
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="about" className="about">
      <div className="container">
        <p className="section-label">About Me</p>
        <div className="about__grid" ref={ref}
          style={{ opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(40px)', transition: 'opacity 0.7s ease, transform 0.7s ease' }}>
          <div className="about__text">
            <h2 className="section-title">Who I Am</h2>
            <p className="about__para"><SearchHighlight text={BIO} query={searchQuery} /></p>
            <div className="about__tags">
              {HIGHLIGHTS.map((h, i) => (
                <span key={h.label} className="about__tag"
                  style={{ transitionDelay: `${i * 0.08}s`, opacity: visible ? 1 : 0, transform: visible ? 'translateY(0)' : 'translateY(12px)', transition: 'opacity 0.5s ease, transform 0.5s ease' }}>
                  <span aria-hidden="true">{h.icon}</span> <SearchHighlight text={h.label} query={searchQuery} />
                </span>
              ))}
            </div>
            <div style={{ marginTop: '2rem' }}>
              <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="btn btn--outline">
                Download Resume
              </a>
            </div>
          </div>
          <div className="about__stats">
            <StatCard number="6+" label="Projects Built" visible={visible} />
            <StatCard number="5+" label="Languages Used" visible={visible} />
            <StatCard number="3+" label="Years Coding" visible={visible} />
            <StatCard number="∞" label="Bugs Fixed" visible={visible} />
          </div>
        </div>
      </div>
    </section>
  );
}
export default About;
EOF

# Update Hero.js terminal with new focus areas
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import SearchHighlight from './SearchHighlight';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Engineer', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
const TAGLINE = "CS student at Pace University who loves building things and solving real problems.";
const GITHUB_URL = 'https://github.com/Zo3945';

function useTypewriter(words, speed = 80, pause = 1800) {
  const [index, setIndex] = useState(0);
  const [subIndex, setSubIndex] = useState(0);
  const [deleting, setDeleting] = useState(false);
  const [text, setText] = useState('');

  useEffect(() => {
    if (!deleting && subIndex === words[index].length) {
      const t = setTimeout(() => setDeleting(true), pause);
      return () => clearTimeout(t);
    }
    if (deleting && subIndex === 0) {
      setDeleting(false);
      setIndex(prev => (prev + 1) % words.length);
      return;
    }
    const t = setTimeout(() => {
      const next = subIndex + (deleting ? -1 : 1);
      setSubIndex(next);
      setText(words[index].substring(0, next));
    }, deleting ? speed / 2 : speed);
    return () => clearTimeout(t);
  }, [subIndex, deleting, index, words, speed, pause]);

  return text;
}

function Hero({ searchQuery }) {
  const role = useTypewriter(ROLES);
  const scrollToProjects = () => document.querySelector('#projects')?.scrollIntoView({ behavior: 'smooth' });

  return (
    <section id="hero" className="hero">
      <div className="hero__bg-grid" aria-hidden="true" />
      <div className="hero__orb hero__orb--1" aria-hidden="true" />
      <div className="hero__orb hero__orb--2" aria-hidden="true" />
      <div className="container hero__inner">
        <div className="hero__content">
          <div className="hero__eyebrow">
            <span className="hero__dot" />
            <span>Available for internships</span>
          </div>
          <h1 className="hero__name">
            <span className="hero__name-line"><SearchHighlight text="Zoheb" query={searchQuery} /></span>
            <span className="hero__name-line hero__name-line--accent"><SearchHighlight text="Khan" query={searchQuery} /></span>
          </h1>
          <div className="hero__role-wrap">
            <span className="hero__role-label">~/ </span>
            <span className="hero__role-text">{role}</span>
            <span className="hero__cursor" aria-hidden="true">|</span>
          </div>
          <p className="hero__tagline"><SearchHighlight text={TAGLINE} query={searchQuery} /></p>
          <div className="hero__actions">
            <Button onClick={scrollToProjects} variant="primary">View My Work</Button>
            <Button href={GITHUB_URL} variant="ghost" external>GitHub Profile</Button>
          </div>
        </div>
        <div className="hero__right">
          <div className="hero__card-wrap">
            <div className="hero__card-border" />
            <div className="hero__card">
              <div className="terminal__bar">
                <span className="terminal__dot terminal__dot--red" />
                <span className="terminal__dot terminal__dot--yellow" />
                <span className="terminal__dot terminal__dot--green" />
                <span className="terminal__title">about-me.js</span>
              </div>
              <div className="terminal__body">
                <pre className="terminal__code">{`const developer = {
  name: "Zoheb Khan",
  school: "Pace University",
  experience: "SWE Intern",
  focus: [
    "Android Development",
    "Python Automation",
    "Web Development",
    "Full Stack Development",
    "AI & Machine Learning",
  ],
  awards: [
    "Best Website @ WiCyS",
  ],
  lookingFor: "SWE Internship",
};`}</pre>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className="hero__scroll-hint" aria-hidden="true">
        <span>scroll</span>
        <div className="hero__scroll-arrow" />
      </div>
    </section>
  );
}
export default Hero;
EOF

# Update Contact.js with SearchHighlight
cat > src/components/Contact.js << 'EOF'
import React from 'react';
import Button from './Button';
import { useScrollAnimation } from './useScrollAnimation';
import SearchHighlight from './SearchHighlight';
import './Contact.css';

const EMAIL = 'Zohebk3945@gmail.com';
const GITHUB = 'https://github.com/Zo3945';
const LINKEDIN = 'https://www.linkedin.com/in/zoheb-khan123/';
const LOCATION = 'New York, NY';

const CONTACT_LINKS = [
  { label: 'Email', value: 'Zohebk3945@gmail.com', href: `mailto:${EMAIL}`, icon: '✉', show: true },
  { label: 'GitHub', value: 'Zo3945', href: GITHUB, icon: '⌥', show: true, external: true },
  { label: 'LinkedIn', value: 'zoheb-khan123', href: LINKEDIN, icon: '◈', show: true, external: true },
];

function ContactCard({ label, value, href, icon, external, index, visible, searchQuery }) {
  return (
    <a className="contact-card" href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateX(0)' : 'translateX(-30px)',
        transition: `opacity 0.5s ease ${index * 0.12}s, transform 0.5s ease ${index * 0.12}s`
      }}>
      <span className="contact-card__icon" aria-hidden="true">{icon}</span>
      <div className="contact-card__text">
        <span className="contact-card__label"><SearchHighlight text={label} query={searchQuery} /></span>
        <span className="contact-card__value"><SearchHighlight text={value} query={searchQuery} /></span>
      </div>
      <span className="contact-card__arrow" aria-hidden="true">→</span>
    </a>
  );
}

function Contact({ searchQuery }) {
  const [ref, visible] = useScrollAnimation(0.1);
  return (
    <section id="contact" className="contact">
      <div className="container">
        <p className="section-label">Contact</p>
        <h2 className="section-title">Let's Connect</h2>
        <p className="section-subtitle">I'm always open to new opportunities, internships, or just a good tech conversation.</p>
        <div className="contact__layout" ref={ref}>
          <div className="contact__links">
            {CONTACT_LINKS.filter(c => c.show).map((c, i) => (
              <ContactCard key={c.label} {...c} index={i} visible={visible} searchQuery={searchQuery} />
            ))}
          </div>
          <div className="contact__cta"
            style={{
              opacity: visible ? 1 : 0,
              transform: visible ? 'translateY(0)' : 'translateY(30px)',
              transition: 'opacity 0.6s ease 0.35s, transform 0.6s ease 0.35s'
            }}>
            <div className="contact__cta-inner">
              <p className="contact__cta-label">// open to opportunities</p>
              <h3 className="contact__cta-heading">Looking for a developer?</h3>
              <p className="contact__cta-text">I'm actively looking for a software engineering internship where I can contribute to real projects and keep growing. Let's talk!</p>
              <div style={{ display: 'flex', gap: '0.75rem', flexWrap: 'wrap' }}>
                <Button href={`mailto:${EMAIL}`} variant="primary">Say Hello</Button>
                <Button href={LINKEDIN} variant="ghost" external>View LinkedIn</Button>
              </div>
              <p className="contact__location"><span aria-hidden="true">◎</span> <SearchHighlight text={LOCATION} query={searchQuery} /></p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
export default Contact;
EOF

echo "✅ Search highlight added to ALL sections!"
