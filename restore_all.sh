#!/bin/bash

# App.js with searchQuery
cat > src/App.js << 'EOF'
import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import About from './components/About';
import Experience from './components/Experience';
import Skills from './components/Skills';
import Projects from './components/Projects';
import GitHubRepos from './components/GitHubRepos';
import Contact from './components/Contact';
import Footer from './components/Footer';
import ParticleBackground from './components/ParticleBackground';
import './styles/App.css';

function App() {
  const [searchQuery, setSearchQuery] = useState('');
  return (
    <div className="app">
      <ParticleBackground />
      <Navbar onSearch={setSearchQuery} />
      <main style={{ position: 'relative', zIndex: 1 }}>
        <Hero searchQuery={searchQuery} />
        <About searchQuery={searchQuery} />
        <Experience searchQuery={searchQuery} />
        <Skills searchQuery={searchQuery} />
        <Projects searchQuery={searchQuery} />
        <GitHubRepos searchQuery={searchQuery} />
        <Contact searchQuery={searchQuery} />
      </main>
      <Footer />
    </div>
  );
}
export default App;
EOF

# Navbar with search + capital labels + easter egg
cat > src/components/Navbar.js << 'EOF'
import React, { useState, useEffect, useRef } from 'react';
import EasterEgg from './EasterEgg';
import './Navbar.css';

const NAV_LINKS = [
  { label: 'About',      href: '#about' },
  { label: 'Experience', href: '#experience' },
  { label: 'Skills',     href: '#skills' },
  { label: 'Projects',   href: '#projects' },
  { label: 'Repos',      href: '#github-repos' },
  { label: 'Contact',    href: '#contact' },
];

function Navbar({ onSearch }) {
  const [scrolled, setScrolled] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [active, setActive] = useState('');
  const [eggTrigger, setEggTrigger] = useState(0);
  const [clicks, setClicks] = useState(0);
  const [searchOpen, setSearchOpen] = useState(false);
  const [query, setQuery] = useState('');
  const timerRef = useRef(null);
  const searchRef = useRef(null);

  useEffect(() => {
    const onScroll = () => {
      setScrolled(window.scrollY > 40);
      const sections = NAV_LINKS.map(l => l.href.replace('#', ''));
      for (let i = sections.length - 1; i >= 0; i--) {
        const el = document.getElementById(sections[i]);
        if (el && window.scrollY >= el.offsetTop - 120) {
          setActive('#' + sections[i]);
          break;
        }
      }
    };
    window.addEventListener('scroll', onScroll);
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  useEffect(() => {
    if (searchOpen && searchRef.current) {
      setTimeout(() => searchRef.current?.focus(), 100);
    }
  }, [searchOpen]);

  const handleLogoClick = (e) => {
    e.stopPropagation();
    window.scrollTo({ top: 0, behavior: 'smooth' });
    const newClicks = clicks + 1;
    setClicks(newClicks);
    clearTimeout(timerRef.current);
    if (newClicks >= 3) { setEggTrigger(prev => prev + 1); setClicks(0); }
    timerRef.current = setTimeout(() => setClicks(0), 2000);
  };

  const handleNavClick = (href, e) => {
    e.stopPropagation();
    e.preventDefault();
    setMenuOpen(false);
    setActive(href);
    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleSearchChange = (e) => {
    e.stopPropagation();
    const val = e.target.value;
    setQuery(val);
    if (onSearch) onSearch(val);
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      const first = document.querySelector('.search-highlight');
      if (first) first.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
    if (e.key === 'Escape') {
      setQuery('');
      if (onSearch) onSearch('');
      setSearchOpen(false);
    }
  };

  return (
    <>
      <EasterEgg trigger={eggTrigger} />
      <header className={`navbar ${scrolled ? 'navbar--scrolled' : ''}`}>
        <div className="container navbar__inner">
          <button className="navbar__logo" onClick={handleLogoClick}>Zoheb Khan</button>
          <nav className={`navbar__links ${menuOpen ? 'navbar__links--open' : ''}`}>
            {NAV_LINKS.map(link => (
              <button key={link.href}
                className={`navbar__link ${active === link.href ? 'navbar__link--active' : ''}`}
                onClick={(e) => handleNavClick(link.href, e)}>
                {link.label}
              </button>
            ))}
            <a href="/Zoheb-s-website/resume.pdf" download="Zoheb_Khan_Resume.pdf" className="navbar__resume">
              Resume ↓
            </a>
          </nav>
          <div className="navbar__search-wrap" onClick={e => e.stopPropagation()}>
            {searchOpen ? (
              <input ref={searchRef} type="text" className="navbar__search-input"
                placeholder="Type + Enter..." value={query}
                onChange={handleSearchChange}
                onKeyDown={handleKeyDown}
                onBlur={() => { if (!query) setSearchOpen(false); }}
                onClick={e => e.stopPropagation()} />
            ) : (
              <button className="navbar__search-btn"
                onClick={(e) => { e.stopPropagation(); setSearchOpen(true); }}>🔍</button>
            )}
          </div>
          <button className={`navbar__hamburger ${menuOpen ? 'navbar__hamburger--open' : ''}`}
            onClick={(e) => { e.stopPropagation(); setMenuOpen(!menuOpen); }}>
            <span /><span /><span />
          </button>
        </div>
      </header>
    </>
  );
}
export default Navbar;
EOF

# Hero with LinkedIn button, alphabetical focus, SearchHighlight
cat > src/components/Hero.js << 'EOF'
import React, { useState, useEffect } from 'react';
import Button from './Button';
import SearchHighlight from './SearchHighlight';
import './Hero.css';

const NAME = 'Zoheb Khan';
const ROLES = ['Software Engineer', 'Android Developer', 'CS Rising Senior', 'Problem Solver'];
const TAGLINE = "CS student at Pace University who loves building things and solving real problems.";
const GITHUB_URL = 'https://github.com/Zo3945';
const LINKEDIN_URL = 'https://www.linkedin.com/in/zoheb-khan123/';

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
            <a href={LINKEDIN_URL} target="_blank" rel="noopener noreferrer" className="btn btn--linkedin">LinkedIn ↗</a>
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
    "AI & Machine Learning",
    "Android Development",
    "Full Stack Dev",
    "Python Automation",
    "Web Development",
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

# Contact with LinkedIn "in" icon + animated border
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
  { label: 'LinkedIn', value: 'zoheb-khan123', href: LINKEDIN, icon: 'in', show: true, external: true },
];

function ContactCard({ label, value, href, icon, external, index, visible, searchQuery }) {
  const isLinkedIn = label === 'LinkedIn';
  return (
    <a className={`contact-card ${isLinkedIn ? 'contact-card--linkedin' : ''}`} href={href}
      target={external ? '_blank' : undefined}
      rel={external ? 'noopener noreferrer' : undefined}
      style={{
        opacity: visible ? 1 : 0,
        transform: visible ? 'translateX(0)' : 'translateX(-30px)',
        transition: `opacity 0.5s ease ${index * 0.12}s, transform 0.5s ease ${index * 0.12}s`
      }}>
      <span className={`contact-card__icon ${isLinkedIn ? 'contact-card__icon--linkedin' : ''}`} aria-hidden="true">{icon}</span>
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

# Add LinkedIn styles to Contact.css
cat >> src/components/Contact.css << 'EOF'

.contact-card--linkedin {
  border-color: rgba(10, 102, 194, 0.4) !important;
}

.contact-card--linkedin:hover {
  border-color: rgba(10, 102, 194, 0.8) !important;
  box-shadow: 0 0 25px rgba(10, 102, 194, 0.25) !important;
}

.contact-card__icon--linkedin {
  background: #0a66c2 !important;
  border-color: #0a66c2 !important;
  color: white !important;
  font-family: var(--font-sans) !important;
  font-weight: 800 !important;
  font-size: 0.85rem !important;
}

.contact__cta-inner {
  position: relative;
  overflow: hidden;
}

.contact__cta-inner::after {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: var(--radius-lg);
  padding: 2px;
  background: linear-gradient(90deg, #7c6aff, #57f0b0, #7c6aff);
  background-size: 300% 100%;
  animation: borderTravel 2s linear infinite;
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask-composite: exclude;
  pointer-events: none;
}

@keyframes borderTravel {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
EOF

echo "✅ Everything restored!"
